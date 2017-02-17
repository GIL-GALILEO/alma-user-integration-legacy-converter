require './lib/classes/user'
require './lib/classes/user_group'
require 'csv'
require 'date'

class UgaUser < User

  FIELD_SEPARATOR = '|'
  FS_CODE_SEPARATOR = '~'

  LAST_ENROLLED_DATE_FORMAT = '%Y%m'
  LAST_PAY_DATE_FORMAT = '%Y%m%d'
  LAST_ENROLLED_EXPIRE_DAYS = 180
  LAST_PAY_EXPIRE_DAYS = 180

  attr_accessor :name, :fs_codes, :class_code, :last_enrolled_date, :last_pay_date

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
      # secondary_id:                     nil,
      barcode:                          22,
      class_code:                       16,
      last_pay_date:                    21,
      last_enrolled_date:               19,
  }

  def initialize(line_data, institution)

    @institution = institution
    @parsed_line = CSV.parse_line(line_data, col_sep: FIELD_SEPARATOR, quote_char: "\x00")
    mapping.each do |attr, index|
      if index
        value = @parsed_line[index]
        self.send("#{attr}=", value ? value.strip : '')
      end
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
    unless names[0] and names[1]
      handle_empty_names
      return
    end
    self.last_name = names[0]
    other_names = names[1].split(' ')
    self.first_name = other_names[0]
    self.middle_name = other_names[1] if other_names[1]
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
    return false unless last_pay_date_obj && is_group_facstaff?
    (DateTime.now - last_pay_date_obj).to_i > LAST_PAY_EXPIRE_DAYS
  end

  def expire_based_on_last_enrolled_date?
    # if the last enrolled date is more than 180 days ago, expire user
    return false unless last_enrolled_date_obj && is_group_student?
    (DateTime.now - last_enrolled_date_obj).to_i > LAST_ENROLLED_EXPIRE_DAYS
  end

  def is_group_facstaff?
    return false unless user_group
    user_group_for_alma.downcase.include?('staff') || user_group_for_alma.downcase.include?('fac')
  end

  def is_group_student?
    return false unless user_group
    user_group_for_alma.downcase.include?('under') || user_group_for_alma.downcase.include?('grad')
  end

  def set_user_group_from_original

    begin

      self.user_group = UserGroup.new @institution, nil, fs_codes.split(FS_CODE_SEPARATOR)

    rescue StandardError => e # todo exception used for flow control...

    end

  end

  def run_expire_checks

      if user_group && ( expire_based_on_last_enrolled_date? || expire_based_on_last_pay_date? )
        self.user_group.exp_date_days = 0
      end

  end

  private

  def handle_empty_names
    self.last_name = 'NONE'
    self.first_name = 'NONE'
  end

end