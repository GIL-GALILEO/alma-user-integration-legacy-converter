require 'minitest/autorun'
require 'yaml'
require './lib/objects/sif_user'

class SifUserTest < MiniTest::Test

  def setup
    test_data = 'ST        2016.01.01           930123456  1User                          Alma                Test                010997 12015.01.01          1000 Elm Road Apt 10                                                                                                              Augusta                                 GA     30123                                                                                                                             3                    alma12@ega.edu                                                                                                                                                                                                                                                                                                     '
    @user = SifUser.new test_data
  end

  def test_has_primary_id

    assert_equal '930123456', @user.primary_id

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

  # def test_has_gender
  #
  #   assert_equal '"gender"', @user.gender
  #
  # end
  #
  # def test_has_user_group
  #
  #   assert_equal '"user_group"', @user.user_group
  #
  # end
  #
  # def test_has_campus_code
  #
  #   assert_equal '"campus_code"', @user.campus_code
  #
  # end
  #
  # def test_has_status
  #
  #   assert_equal '"status"', @user.status
  #
  # end

  def test_has_address_line_1

    assert_equal '1000 Elm Road Apt 10', @user.address_line_1

  end

  # def test_has_address_line_2
  #
  #   assert_equal '"address_line_2"', @user.address_line_2
  #
  # end

  def test_has_address_city

    assert_equal 'Augusta', @user.address_city

  end

  def test_has_address_postal_code

    assert_equal '30123', @user.address_postal_code

  end

  def test_has_address_state_province

    assert_equal 'GA', @user.address_state_province

  end

  # def test_has_address_country
  #
  #   assert_equal '"address_country"', @user.address_country
  #
  # end

  def test_has_email

    assert_equal 'alma12@ega.edu', @user.email

  end

  # def test_has_phone
  #
  #   assert_equal '"phone"', @user.phone
  #
  # end

  def test_primary_id_cannot_be_too_long

    @user.primary_id = 'areallylongstringwithmorethantwohundredandfiftyfivecharactersshouldreturnatruncatedversionofthatsamestringareallylongstringwithmorethantwohundredandfiftyfivecharactersshouldreturnatruncatedversionofthatsamestringareallylongstringwithmorethantwohundredandfiftyfivecharactersshouldreturnatruncatedversionofthatsamestring'
    assert_equal 255, @user.primary_id.length

  end

  def test_campus_code_cannot_be_too_long

    @user.campus_code = 'acampuscodecanbenolongerthanfiftyalphanumericcharacters'
    assert_equal 50, @user.campus_code.length


  end

end
