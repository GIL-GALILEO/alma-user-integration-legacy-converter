require './lib/classes/user'
require './lib/classes/user_group'

# Parser object for standard ZORVLIB Process

class SifUser < User

  USER_SEGMENT_LENGTH       = 120
  ADDRESS_SEGMENT_LENGTH    = 328
  MAXIMUM_ADDRESS_SEGMENTS  = 3

  ADDRESS_TYPE_MAPPING = {
      '1': 'Permanent Address',
      '2': 'Temporary Address',
      '3': 'Email Address'
  }

  GENERAL_MAPPING = {
      original_user_group: [0, 10],
      primary_id:          [31, 42],
      last_name:           [43, 73],
      first_name:          [73, 93],
      middle_name:         [93, 113],
  }

  ADDRESS_SEGMENT_MAPPING = {
      address_type:             [0, 1],
      address_line_1:           [21, 71],
      address_line_2:           [71, 111],
      address_city:             [151, 191],
      address_state_province:   [191, 198],
      address_postal_code:      [198, 208],
      address_country:          [208, 228],
      address_phone:            [228, 253],
      address_mobile_phone:     [258, 288],
  }

  def initialize(line_data, institution, campus = nil)
    @institution = institution
    @line_data = line_data
    @campus = campus

    user_data = extract_user_data
    address_data = extract_addresses

    user_data.each do |attr, value|
        set_value attr, value
    end

    address_data.each do |segment, data_hash|

      case segment.to_s
        when '1'
          # permanent
          set_primary_address(data_hash)
        when '2'
          # temporary
          set_secondary_address(data_hash)
        when '3'
          # email
          set_email_address(data_hash)
        else
          # discard?
      end

    end

    set_user_group_from_original

  end

  def user_segment_length
    USER_SEGMENT_LENGTH
  end

  def address_segment_length
    ADDRESS_SEGMENT_LENGTH
  end

  def maximum_address_segments
    MAXIMUM_ADDRESS_SEGMENTS
  end

  def general_mapping
    GENERAL_MAPPING
  end

  def address_segment_mapping
    ADDRESS_SEGMENT_MAPPING
  end

  def extract_addresses
    address_data = {}
    (1..maximum_address_segments).each do |segment_num|
      address_hash = extract_address_for_segment segment_num
      if address_hash
        address_type = address_hash[:address_type] || segment_num
        address_data[address_type] = address_hash
      end
    end
    address_data
  end

  def extract_address_for_segment(segment_num)
    segment_start = user_segment_length + ( (segment_num - 1) * address_segment_length )
    segment_finish = segment_start + address_segment_length
    address_segment = @line_data[segment_start...segment_finish]
    return nil unless address_segment && address_segment.strip != '' # exit if no address data
    address_data = {}
    address_segment_mapping.each do |attr, width|
      address_data[attr] = extract_from_line((segment_start + width[0]), (segment_start + width[1]))
    end
    address_data
  end

  def extract_user_data
    general_data = {}
    general_mapping.each do |attr, width|
      general_data[attr] = extract_from_line width[0], width[1]
    end
    general_data
  end

  def set_primary_address(data_hash)
    data_hash.delete(:address_type)
    data_hash.each do |attr, value|
      set_value "primary_#{attr}", value
    end
  end

  def set_secondary_address(data_hash)
    data_hash.delete(:address_type)
    data_hash.each do |attr, value|
      set_value "secondary_#{attr}", value
    end
  end

  def set_email_address(data_hash)
    self.email = data_hash[:address_line_1]
  end

  def set_user_group_from_original

    begin

      self.user_group = UserGroup.new(@institution, @campus, original_user_group) if original_user_group
      self.secondary_user_group = UserGroup.new(@institution, @campus, original_secondary_user_group) if original_secondary_user_group

    rescue NoGroupMappingError => e

      unless self.user_group
        @institution.logger.warn "No group mapping found for for user ID: #{self.primary_id}. Using configured default."
        self.user_group = UserGroup.new(@institution, @campus, 'DEFAULT')
      end

    rescue NotImplementedError => e

      raise StandardError.new(e) # case: attempt to map FS code with Campus set

    end

  end

end