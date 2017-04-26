require 'minitest/autorun'
require 'yaml'
require './lib/classes/user'

class UserTest < MiniTest::Test

  def setup

    @user = User.new

  end

  def test_empty_user_booleans

    assert_equal false, @user.primary_address?
    assert_equal false, @user.secondary_address?
    assert_equal false, @user.contact_info?
    assert_equal false, @user.additional_identifiers?

  end

  def test_has_phone_numbers

    @user.secondary_address_mobile_phone = '111-222-3333'

    assert @user.phone_numbers?

  end

  def test_has_scrubbed_email

    @user.email = 'test@test.edu'

    assert_equal 'test@SCRUBBED_test.edu', @user.email

  end

  def test_user_that_receives_no_address_gets_default_value

    @user.primary_address_line_1 = ''

    assert_equal 'No Address Provided', @user.primary_address_line_1

  end

  def test_has_ordered_phone_numbers

    @user.primary_address_phone = '111-222-3333'
    @user.primary_address_mobile_phone = nil
    @user.secondary_address_phone = '123-456-7890'
    @user.secondary_address_mobile_phone = ''

    @user.order_phone_numbers

    assert_equal 2, @user.ordered_phone_numbers.length
    assert_equal '111-222-3333', @user.ordered_phone_numbers[0]
    assert_equal '123-456-7890', @user.ordered_phone_numbers[1]

  end

  def test_has_primary_address

    @user.primary_address_state_province = 'GA'

    assert @user.primary_address?

  end

  def test_has_secondary_address

    @user.secondary_address_state_province = 'GA'

    assert @user.secondary_address?

  end

  def test_has_contact_info

    @user.primary_address_phone = '111-222-3333'

    assert @user.contact_info?

  end

  def test_has_additional_identifiers

    @user.barcode = '100100101000111010101'

    assert @user.additional_identifiers?

    @user.secondary_id = 'username'

    assert @user.additional_identifiers?

    @user.barcode = ''
    @user.secondary_id = ''

    assert !@user.additional_identifiers?

  end


end
