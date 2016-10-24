class User

  MAXIMUM_STRING_VALUE_LENGTH = 255
  USER_ATTRIBUTES = %w(
    primary_id
    first_name
    middle_name
    last_name
    gender
    user_group
    campus_code
    exp_date
    status
    address_line_1
    address_line_2
    address_city
    address_state_province
    address_postal_code
    address_country
    email
    phone
    barcode
    secondary_id
  )

  attr_accessor *USER_ATTRIBUTES

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
  def expiry_date(v)
    @expiry_date = alma_string "#{v}Z", 50
  end

  # STATUS
  # type:         string
  # max_length:   255
  # table:        ContentStructureStatus
  def status=(v)
    @status = alma_string v
  end

  # ADDRESS LINE 1
  # type:         string
  # max_length:   255
  def address_line_1=(v)
    @address_line_1 = alma_string v
  end

  # ADDRESS LINE 2
  # type:         string
  # max_length:   255
  def address_line_2=(v)
    @address_line_2 = alma_string v
  end

  # ADDRESS CITY
  # type:         string
  # max_length:   255
  def address_city=(v)
    @address_city = alma_string v
  end

  # ADDRESS STATE/PROVINCE
  # type:         string
  # max_length:   255
  def address_state_province=(v)
    @address_state_province = alma_string v
  end

  # ADDRESS POSTAL CODE
  # type:         string
  # max_length:   255
  def address_postal_code=(v)
    @address_postal_code = alma_string v
  end

  # ADDRESS COUNTRY
  # type:         string
  # max_length:   255
  def address_country=(v)
    @address_country = alma_string v
  end

  # ADDRESS EMAIL
  # type:         string
  # max_length:   255
  def email=(v)
    @email = alma_string v
  end

  # ADDRESS PHONE
  # type:         string
  # max_length:   255
  def phone=(v)
    @phone = alma_string v
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
    str[0...size] if str
  end

end