require 'minitest/autorun'
require 'yaml'
require './lib/classes/users/vsu_user'
require './lib/classes/institution'

class VsuUserTest < MiniTest::Test

  TEST_DATA_FILE = './config/test_data.yml'

  def setup

    test_data = YAML.load_file TEST_DATA_FILE
    test_inst = Institution.new 'vsu'
    @user = VsuUser.new test_data['vsu_test'], test_inst

  end

  def test_has_user_group

    assert_kind_of UserGroup, @user.user_group

  end

  def test_has_primary_id

    assert_equal '870123456', @user.primary_id

  end

  def test_has_barcode

    assert_nil @user.barcode

  end

  def test_has_first_name

    assert_equal 'Ronald', @user.first_name

  end

  def test_has_middle_name

    assert_equal 'Fry', @user.middle_name

  end

  def test_has_last_name

    assert_equal 'McDonald', @user.last_name

  end

  def test_has_primary_address_line_1

    assert_equal 'Rt 1 Box 100', @user.primary_address_line_1

  end

  def test_has_primary_address_line_2

    assert_equal '1000 W Wilson St', @user.primary_address_line_2

  end

  def test_has_primary_address_city

    assert_equal 'Lakeland', @user.primary_address_city

  end

  def test_has_primary_address_postal_code

    assert_equal '31635', @user.primary_address_postal_code

  end

  def test_has_primary_address_state_province

    assert_equal 'GA', @user.primary_address_state_province

  end

  def test_has_primary_address_country

    assert_equal 'United States', @user.primary_address_country

  end

  def test_has_primary_address_phone

    assert_equal '222-333-4444', @user.primary_address_phone

  end

  def test_has_primary_address_mobile_phone

    assert_nil @user.primary_address_mobile_phone

  end

  def test_has_email

    assert_equal 'frmcdonald@valdosta.edu', @user.email

  end

end
