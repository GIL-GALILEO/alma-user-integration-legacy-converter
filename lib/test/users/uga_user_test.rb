require 'minitest/autorun'
require 'yaml'
require './lib/classes/users/uga_user'
require './lib/classes/institution'
require './lib/util'
include Util::App

class UgaUserTest < MiniTest::Test

  TEST_DATA_FILE = './config/test_data.yml'

  def setup

    test_data = YAML.load_file TEST_DATA_FILE
    test_inst = Institution.new 'uga'
    @user = UgaUser.new test_data['uga_test'], test_inst

  end

  def test_has_primary_id

    assert_equal '810123456', @user.primary_id

  end

  def test_default_user_group_is_nil

    assert_nil UgaUser::DEFAULT_USER_GROUP

  end

  def test_has_name

    assert_equal 'User, Alma Test', @user.name

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

  def test_has_email

    assert_equal 'almauser@uga.edu', @user.email

  end

  def test_has_user_group

    assert_equal 'STAFF', @user.user_group

  end

  def test_has_primary_address_line_1

    assert_equal '200 Broad St', @user.primary_address_line_1

  end

  def test_has_primary_address_city

    assert_equal 'Athens', @user.primary_address_city

  end

  def test_has_primary_address_state

    assert_equal 'GA', @user.primary_address_state_province

  end

  def test_has_primary_address_postal_code

    assert_equal '33333', @user.primary_address_postal_code

  end

  def test_has_primary_address_phone

    assert_equal '9042411080', @user.primary_address_phone

  end

  def test_has_secondary_address_line_1

    assert_equal '100 Main Highway', @user.secondary_address_line_1

  end

  def test_has_secondary_address_city

    assert_equal 'Athens', @user.secondary_address_city

  end

  def test_has_secondary_address_state

    assert_equal 'GA', @user.secondary_address_state_province

  end

  def test_has_secondary_address_postal_code

    assert_equal '30123', @user.secondary_address_postal_code

  end

  def test_has_secondary_address_phone

    assert_equal '9007654321', @user.secondary_address_phone

  end

  def test_has_last_pay_date

    assert_equal '20160831', @user.last_pay_date

  end

  def test_has_last_enrolled_date

    assert_equal '201608', @user.last_enrolled_date

  end

  def test_has_barcode

    assert_equal '1234567891234567', @user.barcode

  end

  def test_has_class_code

    assert_equal 'G', @user.class_code

  end

  def test_has_proper_expiry_date

    date = "#{date_days_from_now(365)}Z"

    assert_equal date, @user.expiry_date

  end

  def test_has_proper_user_group

    assert_equal 'STAFF', @user.user_group

  end

  def test_user_with_multiple_class_codes



  end

end
