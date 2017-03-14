require 'minitest/autorun'
require 'yaml'
require './lib/classes/users/west_ga_user'
require './lib/classes/institution'

class WestGaUserTest < MiniTest::Test

  TEST_DATA_FILE = './config/test_data.yml'

  def setup

    test_data = YAML.load_file TEST_DATA_FILE
    test_inst = Institution.new 'westga'
    @user = WestGaUser.new test_data['west_ga_new_test'], test_inst

  end

  def test_has_user_group

    assert_kind_of UserGroup, @user.user_group

  end

  def test_has_primary_id

    assert_equal '917000000', @user.primary_id

  end

  # def test_has_barcode
  #
  #   assert_equal '917123456', @user.barcode
  #
  # end

  def test_has_first_name

    assert_equal 'Test', @user.first_name

  end

  def test_has_middle_name

    assert_equal 'Sif', @user.middle_name

  end

  def test_has_last_name

    assert_equal 'Name', @user.last_name

  end

  def test_has_primary_address_line_1

    assert_equal '66 Miles Rd', @user.primary_address_line_1

  end

  def test_has_primary_address_line_2

    assert_equal '', @user.primary_address_line_2

  end

  def test_has_primary_address_city

    assert_equal 'Carrollton', @user.primary_address_city

  end

  def test_has_primary_address_postal_code

    assert_equal '30117-8888', @user.primary_address_postal_code

  end

  def test_has_primary_address_state_province

    assert_equal 'GA', @user.primary_address_state_province

  end

  def test_has_primary_address_country

    assert_equal 'USA', @user.primary_address_country

  end

  def test_has_primary_address_phone

    assert_equal '(777)987-6543', @user.primary_address_phone

  end

  def test_has_secondary_address_line_1

    assert_equal '22 Tests Rd', @user.secondary_address_line_1

  end

  def test_has_secondary_address_line_2

    assert_equal '', @user.secondary_address_line_2

  end

  def test_has_secondary_address_city

    assert_equal 'Carrollton', @user.secondary_address_city

  end

  def test_has_secondary_address_postal_code

    assert_equal '30110', @user.secondary_address_postal_code

  end

  def test_has_secondary_address_state_province

    assert_equal 'GA', @user.secondary_address_state_province

  end

  def test_has_secondary_address_country

    assert_equal '', @user.secondary_address_country

  end

  def test_has_secondary_address_phone

    assert_equal '(777)123-4567', @user.secondary_address_phone

  end

  def test_has_email

    assert_equal 'testname5@gmail.com', @user.email

  end

end
