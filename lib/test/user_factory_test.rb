require 'minitest/autorun'
require 'yaml'
require './lib/objects/institution'
require './lib/objects/user_factory'

class UserFactoryTest < MiniTest::Test

  TEST_DATA_FILE = './config/test_data.yml'

  def setup

    @test_inst = Institution.new('test_sif', true)

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

end