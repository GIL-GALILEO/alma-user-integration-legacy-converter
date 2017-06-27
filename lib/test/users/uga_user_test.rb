require 'minitest/autorun'
require 'yaml'
require './lib/classes/user'
require './lib/classes/users/uga_user'
require './lib/classes/institution'
require './lib/util'
include Util::App

# common code for UGA User testing
class UgaUserTest < MiniTest::Test
  TEST_DATA_FILE = './config/uga_test_data.yml'.freeze
end

# tests fields and functionality for patrons specific to UGA
class UgaUserBasicTest < UgaUserTest
  def setup
    test_data = YAML.load_file(TEST_DATA_FILE)['undergrad']
    test_inst = Institution.new 'uga'
    @user = UgaUser.new test_data, test_inst
  end

  def test_has_primary_id
    assert_equal '810222222', @user.primary_id
  end

  def test_has_name
    assert_equal 'Undergrad, Test Student', @user.name
  end

  def test_has_first_name
    assert_equal 'Test', @user.first_name
  end

  def test_has_middle_name
    assert_equal 'Student', @user.middle_name
  end

  def test_has_last_name
    assert_equal 'Undergrad', @user.last_name
  end

  def test_has_email
    assert_equal 'undergrad@uga.edu', @user.email
  end

  def test_has_user_group
    assert_equal 'UNDER PRIV', @user.user_group.alma_name
  end

  def test_has_class_code
    assert_equal 'U', @user.class_code
  end

  def test_has_primary_address_line_1
    assert_equal '101 ADDRESS', @user.primary_address_line_1
  end

  def test_has_primary_address_city
    assert_equal 'CITY', @user.primary_address_city
  end

  def test_has_primary_address_state
    assert_equal 'GA', @user.primary_address_state_province
  end

  def test_has_primary_address_postal_code
    assert_equal '30605', @user.primary_address_postal_code
  end

  def test_has_primary_address_phone
    assert_equal '1112223333', @user.primary_address_phone
  end

  def test_has_secondary_address_line_1
    assert_equal '20 ADDRESS', @user.secondary_address_line_1
  end

  def test_has_secondary_address_city
    assert_equal 'CITY', @user.secondary_address_city
  end

  def test_has_secondary_address_state
    assert_equal 'GA', @user.secondary_address_state_province
  end

  def test_has_secondary_address_postal_code
    assert_equal '30605', @user.secondary_address_postal_code
  end

  def test_has_secondary_address_phone
    assert_equal '', @user.secondary_address_phone
  end

  def test_has_last_pay_date
    assert_equal '', @user.last_pay_date
  end

  def test_has_last_enrolled_date
    assert_equal '201702', @user.last_enrolled_date
  end

  def test_has_last_pay_date_object
    assert_nil@user.last_pay_date_obj
  end

  def test_has_last_enrolled_date_object
    assert_kind_of DateTime, @user.last_enrolled_date_obj
  end

  def test_has_barcode
    assert_equal '6286838999999999', @user.barcode
  end
end

# tests user_group functionality specific to UGA
class UgaUserGroupTest < UgaUserTest
  def setup
    test_data = YAML.load_file(TEST_DATA_FILE)
    staff_test_data = test_data['staff']
    undergraduate_test_data = test_data['undergrad']
    graduate_test_data = test_data['grad']
    both_test_data = test_data['student_and_staff']
    emeritus_test_data = test_data['emeritus']
    retired_test_data = test_data['retired']
    @inst = Institution.new 'uga'
    @staff_user = UgaUser.new staff_test_data, @inst
    @undergraduate_user = UgaUser.new undergraduate_test_data, @inst
    @graduate_user = UgaUser.new graduate_test_data, @inst
    @both_user = UgaUser.new both_test_data, @inst
    @emeritus_user = UgaUser.new emeritus_test_data, @inst
    @retired_user = UgaUser.new retired_test_data, @inst
  end

  def test_staff_user_is_staff
    assert @staff_user.user_group.facstaff?
    assert_equal 'STAFF', @staff_user.user_group.alma_name
  end

  def test_undergraduate_user_is_student
    assert @undergraduate_user.user_group.student?
    assert_equal 'UNDER PRIV', @undergraduate_user.user_group.alma_name
  end

  def test_graduate_user_is_student
    assert @graduate_user.user_group.student?
    assert_equal 'GRAD PRIV', @graduate_user.user_group.alma_name
  end

  def test_both_user_is_facstaff
    assert @both_user.user_group.facstaff?
    assert @both_user.last_enrolled_date_obj && @both_user.last_pay_date_obj
    assert_equal 'FAC', @both_user.user_group.alma_name
    assert_equal(
      "#{date_days_from_now 400}Z",
      @both_user.exp_date_for_alma
    )
  end

  def test_emeritus_user_is_not_expired
    assert_equal(
      "#{date_days_from_now 400}Z",
      @emeritus_user.exp_date_for_alma
    )
  end

  def test_retired_user_is_not_expired
    assert_equal(
      "#{date_days_from_now 400}Z",
      @emeritus_user.exp_date_for_alma
    )
  end
end
