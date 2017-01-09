require './lib/classes/user'
require 'csv'

class UgaUser < User

  FIELD_SEPARATOR = '|'
  FS_CODE_SEPARATOR = '~'

  attr_accessor :name, :class_code, :last_enrolled_date, :last_pay_date

  # todo: distinguish between a value where we want to use a default string value, and one we want to leave blank/nil
  MAPPING = {
      primary_id:                       0,
      name:                             1,
      user_group:                       2,
      primary_address_line_1:           3,
      primary_address_city:             4,
      primary_address_state_province:   5,
      primary_address_postal_code:      6,
      primary_address_phone:            7,
      secondary_address_line_1:         8,
      secondary_address_city:           9,
      secondary_address_state_province: 10,
      secondary_address_postal_code:    11,
      secondary_address_phone:          13,
      email:                            15,
      secondary_id:                     nil,
      barcode:                          22,
      class_code:                       16,
      last_pay_date:                    21,
      last_enrolled_date:               19,
  }

  def initialize(line_data, institution)

    @institution = institution
    @parsed_line = CSV.parse_line(line_data, col_sep: FIELD_SEPARATOR)
    mapping.each do |attr, index|
      if index
        value = @parsed_line[index]
        self.send("#{attr}=", value ? value.strip : '')
      else
        self.send("#{attr}=", 'DEFAULT_VALUE')
      end
    end

    set_alma_user_group_and_expiry_date

  end

  def mapping
    MAPPING
  end

  def name=(full_name)
    @name = full_name
    names = full_name.split(',')
    names.map!(&:strip)
    self.last_name = names[0]
    other_names = names[1].split(' ')
    self.first_name = other_names[0]
    self.middle_name = other_names[1] if other_names[1]
  end

  def set_alma_user_group_and_expiry_date

    fs_codes = @user_group.split(FS_CODE_SEPARATOR)

    user_group = {}
    exp_date_days = DEFAULT_EXPIRY_DATE_DAYS

    fs_codes.each do |fs_code|

      # if FS code has no mapping key, do not generate a user object
      if @institution.groups_data.has_key? fs_code

        alma_name = @institution.groups_data[fs_code]

        group_settings = @institution.groups_settings[alma_name]
        exp_date_days = @institution.groups_settings[alma_name]['exp_date_days'].to_i

        this_user_group = {
            alma_name: alma_name,
            weight: group_settings['weight']
        }

        if user_group.empty? || this_user_group[:weight] > user_group[:weight]
          user_group = this_user_group
        end

      else

        @institution.logger.warn "User Group encountered with no translation configured (#{self.user_group}). Patron will not be included in XML file."
        self.user_group = nil

      end

    end

    self.expiry_date = date_days_from_now exp_date_days

    self.user_group = user_group[:alma_name]

  end

end