require 'minitest/autorun'
require 'yaml'
require './lib/classes/users/ung_user'
require './lib/classes/institution'

class UngUserTest < MiniTest::Test

  TEST_DATA_FILE = './config/test_data.yml'

  def setup

    test_data = YAML.load_file TEST_DATA_FILE
    test_inst = Institution.new 'test_ung'
    @user = UngUser.new test_data['ung_test'], test_inst

  end

  def test_has_user_group

    assert_equal 'UNDERGRAD', @user.user_group

  end

  def test_has_primary_id

    assert_equal '900123456', @user.primary_id

  end

  def test_has_barcode

    assert_nil @user.barcode

  end

  def test_has_first_name

    assert_equal 'Joey', @user.first_name

  end

  def test_has_middle_name

    assert_equal 'D', @user.middle_name

  end

  def test_has_last_name

    assert_equal 'Smith', @user.last_name

  end

  def test_has_primary_address_line_1

    assert_equal '123 Baller Rd', @user.primary_address_line_1

  end

  def test_has_primary_address_line_2

    assert_equal '', @user.primary_address_line_2

  end

  def test_has_primary_address_city

    assert_equal 'Athens', @user.primary_address_city

  end

  def test_has_primary_address_postal_code

    assert_equal '30000', @user.primary_address_postal_code

  end

  def test_has_primary_address_state_province

    assert_equal 'GA', @user.primary_address_state_province

  end

  def test_has_primary_address_country

    assert_equal '', @user.primary_address_country

  end

  def test_has_primary_address_phone

    assert_equal '', @user.primary_address_phone

  end

  def test_has_primary_address_mobile_phone

    assert_nil @user.primary_address_mobile_phone

  end

  def test_has_email

    assert_equal 'JDSMIT2000@ung.edu', @user.email

  end

end
