require 'minitest/autorun'
require 'yaml'
require './lib/classes/users/uga_user'
require './lib/classes/institution'

class UgaUserTest < MiniTest::Test

  TEST_DATA_FILE = './config/test_data.yml'

  def setup

    test_data = YAML.load_file TEST_DATA_FILE
    test_inst = Institution.new 'test_uga'
    @user = UgaUser.new test_data['uga_test'], test_inst

  end

  def test_has_primary_id

    assert_equal @user.primary_id, '810123456'

  end

  def test_has_name

    assert_equal @user.name, 'User, Alma Test'

  end

  def test_has_first_name

    assert_equal @user.first_name, 'Alma'

  end

  def test_has_middle_name

    assert_equal @user.middle_name, 'Test'

  end

  def test_has_last_name

    assert_equal @user.last_name, 'User'

  end

  def test_has_email

    assert_equal @user.email, 'almauser@uga.edu'

  end

  def test_has_user_group

    assert_equal @user.user_group, 'STAFF'

  end

  def test_has_primary_address_line_1

    assert_equal @user.primary_address_line_1, '200 Broad St'

  end

  def test_has_primary_address_city

    assert_equal @user.primary_address_city, 'Athens'

  end

  def test_has_primary_address_state

    assert_equal @user.primary_address_state_province, 'GA'

  end

  def test_has_primary_address_postal_code

    assert_equal @user.primary_address_postal_code, '33333'

  end

  def test_has_primary_address_phone

    assert_equal @user.primary_address_phone, '9042411080'

  end

  def test_has_secondary_address_line_1

    assert_equal @user.secondary_address_line_1, '100 Main Highway'

  end

  def test_has_secondary_address_city

    assert_equal @user.secondary_address_city, 'Athens'

  end

  def test_has_secondary_address_state

    assert_equal @user.secondary_address_state_province, 'GA'

  end

  def test_has_secondary_address_postal_code

    assert_equal @user.secondary_address_postal_code, '30123'

  end

  def test_has_secondary_address_phone

    assert_equal @user.secondary_address_phone, '9007654321'

  end

  def test_has_last_pay_date

    assert_equal @user.last_pay_date, '20160831'

  end

  def test_has_last_enrolled_date

    assert_equal @user.last_enrolled_date, '201608'

  end

  def test_has_barcode

    assert_equal @user.barcode, '1234567891234567'

  end

  def test_has_class_code

    assert_equal @user.class_code, 'G'

  end

  # def test_has_secondary_id
  #
  #   assert_equal @user.secondary_id, 'tbd'
  #
  # end

end
