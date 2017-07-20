require 'minitest/autorun'
require 'yaml'
require './lib/classes/patron'

# tests for CSV Patron User
class PatronTest < MiniTest::Test
  def setup
    test_csv_line = YAML.load_file('./config/test_data.yml')['patron']
    @patron = Patron.new test_csv_line
  end

  def test_identifiers
    assert_equal '123456789', @patron.primary_id
    assert_equal '000000000123456789', @patron.barcode
    assert_equal '900000000', @patron.secondary_id
  end

  def test_groups
    assert_equal 'STAFF', @patron.primary_group
    assert_equal 'STUDENT', @patron.secondary_group
  end

  def test_name
    assert_equal 'Test', @patron.first_name
    assert_equal 'Alma', @patron.middle_name
    assert_equal 'User', @patron.last_name
  end

  def test_blank_gender
    assert !@patron.gender
  end

  def test_campus_code
    assert_equal 'Main Campus', @patron.campus_code
  end

  def test_status
    assert_equal 'Active', @patron.status
  end
  
  def test_expiration_date
    assert_equal '12-30-2020', @patron.expiration_date
  end
  
  def test_primary_address
    assert_equal '123 Main Campus St.', @patron.primary_address_line_1
    assert_equal 'Room 123', @patron.primary_address_line_2
    assert_equal 'Collegeville', @patron.primary_address_city
    assert_equal 'Georgia', @patron.primary_address_state_province
    assert_equal '33333', @patron.primary_address_postal_code
    assert_equal 'USA', @patron.primary_address_country
  end
  
  def test_secondary_address
    assert_equal '555 Home Rd.', @patron.secondary_address_line_1
    assert_equal '', @patron.secondary_address_line_2
    assert_equal 'Homeville', @patron.secondary_address_city
    assert_equal 'Florida', @patron.secondary_address_state_province
    assert_equal '44444', @patron.secondary_address_postal_code
    assert_equal 'United States of Ame', @patron.secondary_address_country
  end

  def test_phone_numbers
    assert_equal '(999) 888 - 7777', @patron.primary_phone
    assert_equal '1234567890', @patron.secondary_phone
  end

  def test_email_addresses
    assert_equal 'email@institution.edu', @patron.primary_email
    assert_equal 'email@home.com', @patron.secondary_email
  end
end