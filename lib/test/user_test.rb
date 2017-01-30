require 'minitest/autorun'
require 'yaml'
require './lib/classes/user'

class UserTest < MiniTest::Test

  def setup

    @user = User.new

  end

  def test_empty_user_booleans

    assert_equal false, @user.has_primary_address?
    assert_equal false, @user.has_secondary_address?
    assert_equal false, @user.has_contact_info?
    assert_equal false, @user.has_additional_identifiers?

  end

  def test_has_primary_address?

    @user.primary_address_state_province = 'GA'

    assert @user.has_primary_address?

  end

  def test_has_secondary_address?

    @user.secondary_address_state_province = 'GA'

    assert @user.has_secondary_address?

  end

  def test_has_contact_info?

    @user.primary_address_phone = '111-222-3333'

    assert @user.has_contact_info?

  end

  def test_has_additional_identifiers

    @user.barcode = '100100101000111010101'

    assert @user.has_additional_identifiers?

  end


end
