require 'minitest/autorun'
require 'yaml'
require './lib/classes/users/sif_user'
require './lib/classes/institution'

class SifUserTest < MiniTest::Test

  TEST_DATA_FILE = './config/test_data.yml'

  def setup

    test_data = YAML.load_file TEST_DATA_FILE
    test_inst = Institution.new 'test_sif'
    @user = SifUser.new test_data['sif_test'], test_inst

  end

  def test_has_primary_id

    assert_equal '930123456', @user.primary_id

  end

  def test_has_first_name

    assert_equal 'Alma', @user.first_name

  end

  def test_has_middle_name

    assert_equal 'Test', @user.middle_name

  end

  def test_has_last_name

    assert_equal 'User', @user.last_name

  end

  def test_has_primary_address_line_1

    assert_equal '1000 Elm Road', @user.primary_address_line_1

  end

  def test_has_primary_address_line_2

    assert_equal 'Apt 10', @user.primary_address_line_2

  end

  def test_has_primary_address_city

    assert_equal 'Augusta', @user.primary_address_city

  end

  def test_has_primary_address_postal_code

    assert_equal '30123', @user.primary_address_postal_code

  end

  def test_has_primary_address_state_province

    assert_equal 'GA', @user.primary_address_state_province

  end

  def test_has_primary_address_country

    assert_equal 'United States of Ame', @user.primary_address_country

  end

  def test_has_primary_address_phone

    assert_equal '(111)222-3333', @user.primary_address_phone

  end

  def test_has_primary_address_mobile_phone

    assert_equal nil, @user.primary_address_mobile_phone

  end

  def test_has_secondary_address_line_1

    assert_equal '1234 Street Rd', @user.secondary_address_line_1

  end

  def test_has_secondary_address_line_2

    assert_equal '', @user.secondary_address_line_2

  end

  def test_has_secondary_address_city

    assert_equal 'Sandersville', @user.secondary_address_city

  end

  def test_has_secondary_address_postal_code

    assert_equal '30000', @user.secondary_address_postal_code

  end

  def test_has_secondary_address_state_province

    assert_equal 'GA', @user.secondary_address_state_province

  end

  def test_has_secondary_address_country

    assert_equal 'United States of Ame', @user.secondary_address_country

  end

  def test_has_secondary_address_phone

    assert_equal '(000)111-2222', @user.secondary_address_phone

  end

  def test_has_secondary_address_mobile_phone

    assert_equal nil, @user.secondary_address_mobile_phone

  end

  def test_has_email

    assert_equal 'alma12@ega.edu', @user.email

  end

  def test_primary_id_cannot_be_too_long

    @user.primary_id = 'areallylongstringwithmorethantwohundredandfiftyfivecharactersshouldreturnatruncatedversionofthatsamestringareallylongstringwithmorethantwohundredandfiftyfivecharactersshouldreturnatruncatedversionofthatsamestringareallylongstringwithmorethantwohundredandfiftyfivecharactersshouldreturnatruncatedversionofthatsamestring'
    assert_equal 255, @user.primary_id.length

  end

  def test_campus_code_cannot_be_too_long

    @user.campus_code = 'acampuscodecanbenolongerthanfiftyalphanumericcharacters'
    assert_equal 50, @user.campus_code.length


  end

end
