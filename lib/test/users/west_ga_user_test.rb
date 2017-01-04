require 'minitest/autorun'
require 'yaml'
require './lib/classes/users/west_ga_user'
require './lib/classes/institution'

class WestGaUserTest < MiniTest::Test

  TEST_DATA_FILE = './config/test_data.yml'

  def setup

    test_data = YAML.load_file TEST_DATA_FILE
    test_inst = Institution.new 'test_westga'
    @user = WestGaUser.new test_data['west_ga_test'], test_inst

  end

  def test_has_user_group

    assert_equal 'student', @user.user_group

  end

  def test_has_primary_id

    assert_equal '917123456', @user.primary_id

  end

  def test_has_barcode

    assert_equal '917123456', @user.barcode

  end

  def test_has_first_name

    assert_equal 'Wendy', @user.first_name

  end

  def test_has_middle_name

    assert_equal 'Lillian', @user.middle_name

  end

  def test_has_last_name

    assert_equal 'Parsons', @user.last_name

  end

  def test_has_primary_address_line_1

    assert_equal '200 Hawks Rd', @user.primary_address_line_1

  end

  def test_has_primary_address_line_2

    assert_equal '', @user.primary_address_line_2

  end

  def test_has_primary_address_city

    assert_equal 'Newnan', @user.primary_address_city

  end

  def test_has_primary_address_postal_code

    assert_equal '30123-5678', @user.primary_address_postal_code

  end

  def test_has_primary_address_state_province

    assert_equal 'GA', @user.primary_address_state_province

  end

  def test_has_primary_address_country

    assert_equal 'United States of Ame', @user.primary_address_country

  end

  def test_has_primary_address_phone

    assert_equal '800-111-2222', @user.primary_address_phone

  end

  def test_has_secondary_address_line_1

    assert_equal '100 Crows Ct', @user.secondary_address_line_1

  end

  def test_has_secondary_address_line_2

    assert_equal '', @user.secondary_address_line_2

  end

  def test_has_secondary_address_city

    assert_equal 'Newnan', @user.secondary_address_city

  end

  def test_has_secondary_address_postal_code

    assert_equal '30123', @user.secondary_address_postal_code

  end

  def test_has_secondary_address_state_province

    assert_equal 'GA', @user.secondary_address_state_province

  end

  def test_has_secondary_address_country

    assert_equal '', @user.secondary_address_country

  end

  def test_has_secondary_address_phone

    assert_equal '', @user.secondary_address_phone

  end

  def test_has_email

    assert_equal 'wendylil@my.westga.edu', @user.email

  end

end
