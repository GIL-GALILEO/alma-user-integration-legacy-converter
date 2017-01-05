require 'minitest/autorun'
require 'yaml'
require './lib/classes/users/sif_user'
require './lib/classes/institution'
require './lib/classes/run_set'
require './lib/classes/templater'

class TemplaterTest < MiniTest::Test

  TEST_DATA_FILE = './config/test_data.yml'

  def setup

    @test_data = YAML.load_file TEST_DATA_FILE

    @test_run_set = RunSet.new
    @test_run_set.inst = Institution.new('test_sif')
    @test_run_set.config = {}

    @users = [ SifUser.new(@test_data['sif_test'], @test_run_set.inst) ]

    @xml = Templater.run(@users, @test_run_set)


  end

  def test_returns_file

    assert_kind_of File, @xml

  end

end