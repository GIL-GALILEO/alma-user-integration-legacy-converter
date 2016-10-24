require 'minitest/autorun'
require 'yaml'
require './lib/objects/sif_user'
require './lib/objects/institution'
require './lib/objects/templater'

class TemplaterTest < MiniTest::Test

  TEST_DATA_FILE = './config/test_data.yml'

  def setup

    test_data = YAML.load_file TEST_DATA_FILE

    @test_inst = Institution.new('test_sif', true)

    @users = [ SifUser.new(test_data['sif_test'], @test_inst) ]

  end

  def test_returns_xml

    assert_kind_of String, Templater.run(@users, @test_inst)

  end

end