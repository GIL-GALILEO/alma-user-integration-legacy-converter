require 'minitest/autorun'
require 'yaml'
require './lib/classes/users/ung_user'
require './lib/classes/institution'

class UngUserTest < MiniTest::Test

  TEST_DATA_FILE = './config/test_data.yml'

  def setup

    test_data = YAML.load_file TEST_DATA_FILE
    test_inst = Institution.new 'ung'
    @user = UngUser.new test_data['sif_test'], test_inst

  end

  def test_has_barcode

    assert_equal @user.primary_id, @user.barcode

  end

end
