require 'minitest/autorun'
require 'yaml'
require './lib/classes/file_handler'
require './lib/classes/institution'
require './lib/classes/user_factory'
require './lib/classes/templater'

class TemplaterTest < MiniTest::Test

  TEST_DATA_FILE = './config/test_data.yml'

  def setup

    institution = Institution.new 'test_sif'
    run_set = FileHandler.new(institution).run_set
    users = UserFactory.generate run_set

    @xml = Templater.run users, run_set

  end

  def test_returns_file

    assert_kind_of File, @xml

  end

end