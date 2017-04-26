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
  MAPPING = {
    primary_id:                       0,
    name:                             1,
    fs_codes:                         2,
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
    class_code:                       16,
    last_enrolled_date:               19,
    last_pay_date:                    21,
    barcode:                          22
  }.freeze

  def initialize(line_data, institution, campus = nil)
    @institution = institution
    @parsed_line = CSV.parse_line(
      line_data, col_sep: FIELD_SEPARATOR, quote_char: "\x00"
    )
    mapping.each do |attr, index|
      set_attribute_value(attr, index) if index
    end
    set_user_group_from_original
    run_expire_checks
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
    # if the last pay date is more than 180 days ago, expire user
    return false unless last_pay_date_obj && user_group.facstaff?
    (DateTime.now - last_pay_date_obj).to_i > LAST_PAY_EXPIRE_DAYS
  end

  def expire_based_on_last_enrolled_date?
    # if the last enrolled date is more than 180 days ago, expire user
    return false unless last_enrolled_date_obj && user_group.student?
    (DateTime.now - last_enrolled_date_obj).to_i > LAST_ENROLLED_EXPIRE_DAYS
  end

  def set_user_group_from_original
    self.user_group = UserGroup.new(
      @institution,
      nil,
      nil,
      fs_codes.split(FS_CODE_SEPARATOR),
      class_code
    )
  rescue StandardError # TODO: exception used for flow control...
    self.user_group = nil
  rescue NotImplementedError => e
    raise StandardError, e # case: attempt to map FS code with Campus set
  end

  def run_expire_checks
    user_group.exp_days = 0 if user_group &&
                               (expire_based_on_last_enrolled_date? ||
                               expire_based_on_last_pay_date?)
  end

  private

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

end