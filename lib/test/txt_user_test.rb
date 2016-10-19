require 'minitest/autorun'
require 'yaml'
require 'csv'
require './lib/objects/txt_user'
require './lib/objects/institution'

class TxtUserTest < MiniTest::Test

  TEST_DATA_FILE = './config/test_data.yml'

  def setup

    test_data = YAML.load_file TEST_DATA_FILE
    test_inst = Institution.new 'test_txt', true
    @user = TxtUser.new test_data['txt_test'], test_inst

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

end
