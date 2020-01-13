require './lib/classes/user'
require './lib/classes/user_group'
require 'csv'
require 'date'

# specialized user functionality and attributes for UGA
class UgaUser < User
  attr_accessor :name, :fs_codes, :class_code, :last_enrolled_date, :last_pay_date
  FIELD_SEPARATOR = '|'.freeze
  FS_CODE_SEPARATOR = '~'.freeze
  LAST_ENROLLED_DATE_FORMAT = '%Y%m'.freeze
  LAST_PAY_DATE_FORMAT = '%Y%m%d'.freeze
  LAST_ENROLLED_EXPIRE_DAYS = 180
  LAST_PAY_EXPIRE_DAYS = 60
  NEVER_EXPIRE_FS_CODES = %w(04 08).freeze
  MAPPING = {
    primary_id:                       0,  # CAN
    name:                             1,  # NAME
    fs_codes:                         2,  # FSCODES
    primary_address_line_1:           3,  # LA
    primary_address_city:             4,  # LC
    primary_address_state_province:   5,  # LS
    primary_address_postal_code:      6,  # LZ
    primary_address_phone:            7,  # LP
    secondary_address_line_1:         8,  # PA
    secondary_address_city:           9,  # PC
    secondary_address_state_province: 10, # PS
    secondary_address_postal_code:    11, # PZ
                                          # PCT
    secondary_address_phone:          13, # PP
                                          # RA
    email:                            15, # EMAIL
    class_code:                       16, # CLASS
                                          # SCHLN
                                          # MAJ
    last_enrolled_date:               19, # LTA
                                          # DPTN
    last_pay_date:                    21, # RU
    barcode:                          22  # LIBBAR
  }.freeze

  def initialize(line_data, institution, _campus = nil)
    @institution = institution
    @parsed_line = CSV.parse_line(
      line_data, col_sep: FIELD_SEPARATOR, quote_char: "\x00"
    )
    mapping.each do |attr, index|
      set_attribute_value(attr, index) if index
    end
    set_user_group_from_original
    run_expire_checks unless never_expire
    self
  end

  def mapping
    MAPPING
  end

  def name=(full_name)
    @name = full_name
    names = full_name.split(',')
    names.map!(&:strip)
    unless names[0] && names[1]
      handle_empty_names
      return
    end
    other_names = names[1].split(' ')
    set_names names, other_names
  end

  def last_pay_date_obj
    return nil if last_pay_date.to_s.empty?
    DateTime.strptime last_pay_date, LAST_PAY_DATE_FORMAT
  end

  def last_enrolled_date_obj
    return nil if last_enrolled_date.to_s.empty?
    DateTime.strptime last_enrolled_date, LAST_ENROLLED_DATE_FORMAT
  end

  def expire_based_on_last_pay_date?
    return false unless user_group.facstaff?
    last_pay_date == '' || ((DateTime.now - last_pay_date_obj).to_i > LAST_PAY_EXPIRE_DAYS)
  end

  def expire_based_on_last_enrolled_date?
    return false unless user_group.student?
    last_enrolled_date == '' || ((DateTime.now - last_enrolled_date_obj).to_i > LAST_ENROLLED_EXPIRE_DAYS)
  end

  def set_user_group_from_original
    self.user_group = UserGroup.new(
      @institution,
      nil,
      nil,
      fs_code_array,
      class_code
    )
  rescue StandardError # TODO: exception used for flow control...
    self.user_group = nil
  rescue NotImplementedError => e
    raise StandardError, e # case: attempt to map FS code with Campus set
  end

  def run_expire_checks
    case user_group.type
    when 'facstaff'
      user_group.exp_days = 0 if expire_based_on_last_pay_date?
    when 'student'
      user_group.exp_days = 0 if expire_based_on_last_enrolled_date?
    end
  end

  private

  def never_expire
    fs_code_array & NEVER_EXPIRE_FS_CODES
  end

  def set_names(names, other_names)
    self.last_name = names[0]
    self.first_name = other_names[0]
    self.middle_name = other_names[1] if other_names[1]
  end

  def set_attribute_value(attr, index)
    value = @parsed_line[index]
    send("#{attr}=", value ? value.strip : '')
  end

  def handle_empty_names
    self.last_name = 'NONE'
    self.first_name = 'NONE'
  end

  def fs_code_array
    fs_codes.split(FS_CODE_SEPARATOR)
  end

end