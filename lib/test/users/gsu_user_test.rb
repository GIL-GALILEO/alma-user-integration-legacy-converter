require 'minitest/autorun'
require 'yaml'
require './lib/classes/users/gsu_user'
require './lib/classes/institution'

class GsuUserTest < MiniTest::Test

  TEST_DATA_FILE = './config/test_data.yml'

  def setup

    test_data = YAML.load_file TEST_DATA_FILE
    test_inst = Institution.new 'gsu'
    @user = GsuUser.new test_data['gsu_test'], test_inst

  end

  def test_has_original_user_group

    assert_equal 'PUL1', @user.original_user_group

  end

  def test_has_user_group_object

    assert_kind_of UserGroup, @user.user_group

  end

  def test_has_primary_id

    assert_equal '001234567', @user.primary_id

  end

  def test_has_barcode

    assert_equal 'S123456', @user.barcode

  end

  def test_has_first_name

    assert_equal 'Brandy', @user.first_name

  end

  def test_has_middle_name

    assert_equal 'Marie', @user.middle_name

  end

  def test_has_last_name

    assert_equal 'Smithwick', @user.last_name

  end

  def test_has_primary_address_line_1

    assert_equal '1000 Riverfield Drive', @user.primary_address_line_1

  end

  def test_has_primary_address_line_2

    assert_equal '', @user.primary_address_line_2

  end

  def test_has_primary_address_city

    assert_equal 'Marietta', @user.primary_address_city

  end

  def test_has_primary_address_postal_code

    assert_equal '30000', @user.primary_address_postal_code

  end

  def test_has_primary_address_state_province

    assert_equal 'GA', @user.primary_address_state_province

  end
  #
  # def test_has_primary_address_country
  #
  #   assert_equal 'United States of Ame', @user.primary_address_country
  #
  # end
  #
  # def test_has_primary_address_phone
  #
  #   assert_equal '(111)222-3333', @user.primary_address_phone
  #
  # end
  #
  # def test_has_primary_address_mobile_phone
  #
  #   assert_equal nil, @user.primary_address_mobile_phone
  #
  # end
  #
  # def test_has_secondary_address_line_1
  #
  #   assert_equal '1234 Street Rd', @user.secondary_address_line_1
  #
  # end
  #
  # def test_has_secondary_address_line_2
  #
  #   assert_equal '', @user.secondary_address_line_2
  #
  # end
  #
  # def test_has_secondary_address_city
  #
  #   assert_equal 'Sandersville', @user.secondary_address_city
  #
  # end
  #
  # def test_has_secondary_address_postal_code
  #
  #   assert_equal '30000', @user.secondary_address_postal_code
  #
  # end
  #
  # def test_has_secondary_address_state_province
  #
  #   assert_equal 'GA', @user.secondary_address_state_province
  #
  # end
  #
  # def test_has_secondary_address_country
  #
  #   assert_equal 'United States of Ame', @user.secondary_address_country
  #
  # end
  #
  # def test_has_secondary_address_phone
  #
  #   assert_equal '(000)111-2222', @user.secondary_address_phone
  #
  # end
  #
  # def test_has_secondary_address_mobile_phone
  #
  #   assert_equal nil, @user.secondary_address_mobile_phone
  #
  # end
  #
  def test_has_email

    assert_equal 'bsmithwick1@student.gsu.edu', @user.email

  end

end
