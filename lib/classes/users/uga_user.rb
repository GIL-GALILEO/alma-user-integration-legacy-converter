require './lib/classes/user'
require 'csv'
require 'date'

class UgaUser < User

  FIELD_SEPARATOR = '|'
  FS_CODE_SEPARATOR = '~'

  LAST_ENROLLED_DATE_FORMAT = '%Y%m'
  LAST_PAY_DATE_FORMAT = '%Y%m%d'
  LAST_ENROLLED_EXPIRE_DAYS = 180
  LAST_PAY_EXPIRE_DAYS = 180

  DEFAULT_USER_GROUP = nil

  attr_accessor :name, :class_code, :last_enrolled_date, :last_pay_date

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
      # secondary_id:                     nil,
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
    user_group.downcase.include?('staff') || user_group.downcase.include?('fac')
  end

  def is_group_student?
    return false unless user_group
    user_group.downcase.include?('under') || user_group.downcase.include?('grad')
  end

  def set_alma_user_group_and_expiry_date

    fs_codes = @user_group.split(FS_CODE_SEPARATOR)

    exp_date_days = DEFAULT_EXPIRY_DATE_DAYS

    user_group = nil

    fs_codes.each do |fs_code|

      # if FS code has no mapping key, do not set a user_group value
      if @institution.groups_data.has_key? fs_code

        alma_name = @institution.groups_data[fs_code]

        group_settings = @institution.groups_settings[alma_name]
        exp_date_days = @institution.groups_settings[alma_name]['exp_date_days'].to_i

        this_user_group = {
            alma_name: alma_name,
            weight: group_settings['weight']
        }

        if !user_group || this_user_group[:weight] > user_group[:weight]
          user_group = this_user_group
        end

      end

    end

    if user_group

      self.user_group = user_group[:alma_name]

      if expire_based_on_last_enrolled_date? || expire_based_on_last_pay_date?
        self.expiry_date = date_days_from_now 0
      else
        self.expiry_date = date_days_from_now exp_date_days
      end

    else

      @institution.logger.info("Patron record had no translatable FS codes in (#{fs_codes.join(', ')}). Patron will not be added to Alma XML.")
      self.user_group = nil # set user group to nil so user is not subject to further processing

    end

  end

end