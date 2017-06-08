require 'minitest/autorun'
require 'yaml'
require './lib/classes/users/csu_user'
require './lib/classes/institution'

class CsuUserTest < MiniTest::Test
  TEST_DATA_FILE = './config/test_data.yml'.freeze

  def setup
    test_data = YAML.load_file TEST_DATA_FILE
    test_inst = Institution.new 'csu'
    @user = CsuUser.new test_data['csu_test'], test_inst
  end

  def test_has_barcode
    assert_equal "201#{@user.primary_id}", @user.barcode
  end

end
