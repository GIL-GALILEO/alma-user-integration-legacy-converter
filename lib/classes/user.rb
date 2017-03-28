require './lib/util'
require 'yaml'
include Util::App
include Util::File

class User

  attr_accessor :original_user_group, :original_secondary_user_group, :original_expiry_date, :exp_date_override, :user_group, :secondary_user_group

  COUNTRIES_CODE_TABLE_FILE = './config/countries.yml'.freeze

  DEFAULT_EXPIRY_DATE_DAYS = 365
  DEFAULT_USER_GROUP = 'unknown'.freeze

  MAXIMUM_STRING_VALUE_LENGTH = 255
  USER_ATTRIBUTES = %w(
    primary_id
    first_name
    middle_name
    last_name
    gender
    original_user_group
    original_expiry_date
    campus_code
    status
    primary_address_line_1
    primary_address_line_2
    primary_address_city
    primary_address_state_province
    primary_address_postal_code
    primary_address_country
    primary_address_phone
    primary_address_mobile_phone
    secondary_address_line_1
    secondary_address_line_2
    secondary_address_city
    secondary_address_state_province
    secondary_address_postal_code
    secondary_address_country
    secondary_address_phone
    secondary_address_mobile_phone
    email
    barcode
    secondary_id
  ).freeze

  attr_reader *USER_ATTRIBUTES

  def has_secondary_address?
    !(@secondary_address_line_1.to_s.empty? &&
      @secondary_address_line_2.to_s.empty? &&
      @secondary_address_city.to_s.empty? &&
      @secondary_address_state_province.to_s.empty? &&
      @secondary_address_postal_code.to_s.empty? &&
      @secondary_address_country.to_s.empty?)
  end
  
  def has_primary_address?
    !(@primary_address_line_1.to_s.empty? &&
      @primary_address_line_2.to_s.empty? &&
      @primary_address_city.to_s.empty? &&
      @primary_address_state_province.to_s.empty? &&
      @primary_address_postal_code.to_s.empty? &&
      @primary_address_country.to_s.empty?)
  end

  def has_contact_info?
    (
      has_primary_address? ||
      has_secondary_address? ||
      !@email.to_s.empty? ||
      !@primary_address_phone.to_s.empty?
    )
  end

  def has_phone_numbers?
    has_primary_phone_numbers? || has_secondary_phone_numbers?
  end

  def has_primary_phone_numbers?
    !(@primary_address_phone.to_s.empty? && @primary_address_mobile_phone.to_s.empty?)
  end

  def has_secondary_phone_numbers?
    !(@secondary_address_phone.to_s.empty? && @secondary_address_mobile_phone.to_s.empty?)
  end

  def has_additional_identifiers?
    !@barcode.to_s.empty? || !@secondary_id.to_s.empty?
  end

  def order_phone_numbers
    @ordered_phone_numbers = [
        @primary_address_phone,
        @primary_address_mobile_phone,
        @secondary_address_phone,
        @secondary_address_mobile_phone
    ].reject do |pn|
      pn.to_s.empty?
    end
  end

  def ordered_phone_numbers
    @ordered_phone_numbers
  end

  def user_group_for_alma
    if user_group && secondary_user_group
      heavier_group = user_group.is_heavier_than?(secondary_user_group) ? user_group : secondary_user_group
      alma_string heavier_group.alma_name
    else
      alma_string user_group.alma_name || secondary_user_group.alma_name
    end
  end

  def exp_date_for_alma
    if exp_date_override
      exp_date_override
    else
      alma_date(date_days_from_now(@user_group.exp_date_days))
    end
  end

  # ALMA PRIMARY ID
  # type:         string
  # max_length:   255
  def primary_id=(v)
    @primary_id = alma_string v
  end

  # FIRST NAME
  # type:         string
  # max_length:   255
  def first_name=(v)
    @first_name = alma_string v
  end

  # MIDDLE NAME
  # type:         string
  # max_length:   255
  def middle_name=(v)
    @middle_name = alma_string v
  end

  # LAST NAME
  # type:         string
  # max_length:   255
  def last_name=(v)
    @last_name = alma_string v
  end

  # GENDER
  # type:         string
  # max_length:   255
  # table:        Genders
  def gender=(v)
    @gender = alma_string v
  end

  # CAMPUS CODE
  # type:         string
  # max_length:   50
  # override:     false
  def campus_code=(v)
    @campus_code = alma_string v, 50
  end

  # STATUS
  # type:         string
  # max_length:   255
  # table:        ContentStructureStatus
  def status=(v)
    @status = alma_string v
  end

  # PRIMARY ADDRESS LINE 1
  # type:         string
  # max_length:   255
  def primary_address_line_1=(v)
    @primary_address_line_1 = alma_string v
  end

  # PRIMARY ADDRESS LINE 2
  # type:         string
  # max_length:   255
  def primary_address_line_2=(v)
    @primary_address_line_2 = alma_string v
  end

  # PRIMARY ADDRESS CITY
  # type:         string
  # max_length:   255
  def primary_address_city=(v)
    @primary_address_city = alma_string v
  end

  # PRIMARY ADDRESS STATE/PROVINCE
  # type:         string
  # max_length:   255
  def primary_address_state_province=(v)
    @primary_address_state_province = alma_string v
  end

  # PRIMARY ADDRESS POSTAL CODE
  # type:         string
  # max_length:   255
  def primary_address_postal_code=(v)
    @primary_address_postal_code = alma_string v
  end

  # PRIMARY ADDRESS COUNTRY
  # type:         string
  # max_length:   255
  def primary_address_country=(v)
    @primary_address_country = alma_string(alma_approved_country(v))
  end

  # PRIMARY ADDRESS PHONE
  # type:         string
  # max_length:   255
  def primary_address_phone=(v)
    @primary_address_phone = alma_string v
  end

  # PRIMARY ADDRESS MOBILE PHONE
  # type:         string
  # max_length:   255
  def primary_address_mobile_phone=(v)
    @primary_address_mobile_phone = alma_string v
  end

  # SECONDARY ADDRESS LINE 1
  # type:         string
  # max_length:   255
  def secondary_address_line_1=(v)
    @secondary_address_line_1 = alma_string v
  end

  # SECONDARY ADDRESS LINE 2
  # type:         string
  # max_length:   255
  def secondary_address_line_2=(v)
    @secondary_address_line_2 = alma_string v
  end

  # SECONDARY ADDRESS CITY
  # type:         string
  # max_length:   255
  def secondary_address_city=(v)
    @secondary_address_city = alma_string v
  end

  # SECONDARY ADDRESS STATE/PROVINCE
  # type:         string
  # max_length:   255
  def secondary_address_state_province=(v)
    @secondary_address_state_province = alma_string v
  end

  # SECONDARY ADDRESS POSTAL CODE
  # type:         string
  # max_length:   255
  def secondary_address_postal_code=(v)
    @secondary_address_postal_code = alma_string v
  end

  # SECONDARY ADDRESS COUNTRY
  # type:         string
  # max_length:   255
  def secondary_address_country=(v)
    @secondary_address_country = alma_string v
  end

  # SECONDARY ADDRESS PHONE
  # type:         string
  # max_length:   255
  def secondary_address_phone=(v)
    @secondary_address_phone = alma_string v
  end

  # SECONDARY ADDRESS MOBILE PHONE
  # type:         string
  # max_length:   255
  def secondary_address_mobile_phone=(v)
    @secondary_address_mobile_phone = alma_string v
  end

  # ADDRESS EMAIL
  # type:         string
  # max_length:   255
  def email=(v)
    @email = scrubbed_email(alma_string v)
  end

  # BARCODE
  # type:         string
  # max_length:   255
  def barcode=(v)
    @barcode = alma_string v
  end

  # SECONDARY ID
  # type:         string
  # max_length:   255
  def secondary_id=(v)
    @secondary_id = alma_string v
  end

  private

  def alma_string(str, size = MAXIMUM_STRING_VALUE_LENGTH)
    xml_safe(str[0...size]) if str
  end

  def alma_date(date_str)
    "#{date_str}Z"
  end

  # todo temporary function to scrub email addresses before Alma goes live
  def scrubbed_email(email)
    email.sub '@', '@SCRUBBED_'
  end

  def xml_safe(string)
    string
        .gsub('&', '&amp;')
        .gsub('"', '&quot;')
        .gsub("'", '&apos;')
        .gsub('<', '&lt;')
        .gsub('>', '&gt;')
        .gsub("\u001A", '')
  end

  def alma_approved_country(voyager_country)
    countries_hash = YAML.load_file COUNTRIES_CODE_TABLE_FILE
    countries_hash[voyager_country] || ''
  end

end