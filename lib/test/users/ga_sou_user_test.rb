require 'minitest/autorun'
require 'yaml'
require './lib/classes/users/ga_sou_user'
require './lib/classes/institution'

class GaSouUserTest < MiniTest::Test

  TEST_DATA_FILE = './config/test_data.yml'

  def setup

    test_data = YAML.load_file TEST_DATA_FILE
    test_inst = Institution.new 'gasou'
    @user = GaSouUser.new test_data['ga_sou_test'], test_inst

  end

  def test_has_user_group

    assert_equal 'ST', @user.user_group

  end

  def test_has_primary_id

    assert_equal '900123123', @user.primary_id

  end

  def test_has_barcode

    assert_equal '900123123900123123', @user.barcode

  end

  def test_has_first_name

    assert_equal 'Lily', @user.first_name

  end

  def test_has_middle_name

    assert_equal 'Jane', @user.middle_name

  end

  def test_has_last_name

    assert_equal 'Zirkowski', @user.last_name

  end

  def test_has_primary_address_line_1

    assert_equal '123 Midway Avenue', @user.primary_address_line_1

  end

  def test_has_primary_address_line_2

    assert_equal '', @user.primary_address_line_2

  end

  def test_has_primary_address_city

    assert_equal 'Athens', @user.primary_address_city

  end

  def test_has_primary_address_postal_code

    assert_equal '30123-4321', @user.primary_address_postal_code

  end

  def test_has_primary_address_state_province

    assert_equal 'GA', @user.primary_address_state_province

  end

  def test_has_primary_address_country

    assert_equal '', @user.primary_address_country

  end

  def test_has_primary_address_phone

    assert_equal '(000)123-4567', @user.primary_address_phone

  end

  def test_has_primary_address_mobile_phone

    assert_nil @user.primary_address_mobile_phone

  end

  def test_has_secondary_address_line_1

    assert_equal 'no address found', @user.secondary_address_line_1

  end

  def test_has_secondary_address_line_2

    assert_equal '', @user.secondary_address_line_2

  end

  def test_has_secondary_address_city

    assert_equal '', @user.secondary_address_city

  end

  def test_has_secondary_address_postal_code

    assert_equal '', @user.secondary_address_postal_code

  end

  def test_has_secondary_address_state_province

    assert_equal '', @user.secondary_address_state_province

  end

  def test_has_secondary_address_country

    assert_equal '', @user.secondary_address_country

  end

  def test_has_secondary_address_phone

    assert_equal '', @user.secondary_address_phone

  end

  def test_has_secondary_address_mobile_phone

    assert_nil @user.secondary_address_mobile_phone

  end

  def test_has_email

    assert_equal 'lily_jane_zbikowski@GeorgiaSouthern.edu', @user.email

  end

end
