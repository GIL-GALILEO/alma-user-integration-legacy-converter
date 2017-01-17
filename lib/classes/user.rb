require './lib/util'
include Util::App
include Util::File

class User

  DEFAULT_EXPIRY_DATE_DAYS = 365
  DEFAULT_USER_GROUP = 'unknown'

  MAXIMUM_STRING_VALUE_LENGTH = 255
  USER_ATTRIBUTES = %w(
    primary_id
    first_name
    middle_name
    last_name
    gender
    user_group
    campus_code
    expiry_date
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
  )

  attr_reader *USER_ATTRIBUTES

  def has_secondary_address?
    !!(@secondary_address_line_1 ||
      @secondary_address_line_2 ||
      @secondary_address_city ||
      @secondary_address_state_province ||
      @secondary_address_postal_code ||
      @secondary_address_country)
  end
  
  def has_primary_address?
    !!(@primary_address_line_1 ||
      @primary_address_line_2 ||
      @primary_address_city ||
      @primary_address_state_province ||
      @primary_address_postal_code ||
      @primary_address_country)
  end

  def has_contact_info?
    !!(has_primary_address? ||
      has_secondary_address? ||
      @email ||
      @primary_address_phone)
  end

  def has_additional_identifiers?
    !!(@barcode || @secondary_id)
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

  # USER_GROUP
  # type:         string
  # max_length:   255
  # table:        UserGroups
  # override:     false
  def user_group=(v)
    @user_group = alma_string v
  end

  # CAMPUS CODE
  # type:         string
  # max_length:   50
  # override:     false
  def campus_code=(v)
    @campus_code = alma_string v, 50
  end

  # EXPIRY DATE
  # type:         string
  # max_length:   50
  # format:       2030-01-16Z
  def expiry_date=(v)
    @expiry_date = alma_string "#{v}Z", 50
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
    @primary_address_country = alma_string v
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
  def primary_mobile_phone=(v)
    @primary_mobile_phone = alma_string v
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
  def secondary_mobile_phone=(v)
    @secondary_mobile_phone = alma_string v
  end

  # ADDRESS EMAIL
  # type:         string
  # max_length:   255
  def email=(v)
    @email = alma_string v
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

  def xml_safe(string)
    string
        .gsub('&','&amp;')
        .gsub('"','&quot;')
        .gsub("'",'&apos;')
        .gsub('<','&lt;')
        .gsub('>','&gt;')
  end

end