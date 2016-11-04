require 'minitest/autorun'
require 'yaml'
require './lib/objects/institution'
require './lib/objects/user_factory'

class UserFactoryTest < MiniTest::Test

  TEST_DATA_FILE = './config/test_data.yml'

  def setup

    @test_inst = Institution.new('test_sif')

  end

  def test_error_on_bad_institution

    assert_raises StandardError do
      UserFactory.generate('blah')
    end

  end

  def test_returns_an_array_of_users

    result = UserFactory.generate(@test_inst)

    assert_kind_of Array, result
    assert_kind_of SifUser, result[0]

  end

  def test_user_has_barcode_from_file

    result = UserFactory.generate(@test_inst)

    assert_equal '87654321930123456', result[0].barcode

  end

  def test_user_has_expiry_date_from_file

    result = UserFactory.generate(@test_inst)

    assert_equal '2044-12-20Z', result[0].expiry_date

  end

  def test_user_has_alma_patron_group

    result = UserFactory.generate(@test_inst)

    assert_equal 'ALMA UNDERGRAD', result[0].user_group

  end

end