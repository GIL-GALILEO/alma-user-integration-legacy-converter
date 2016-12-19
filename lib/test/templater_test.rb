require 'minitest/autorun'
require 'yaml'
require './lib/classes/users/sif_user'
require './lib/classes/institution'
require './lib/classes/templater'

class TemplaterTest < MiniTest::Test

  TEST_DATA_FILE = './config/test_data.yml'

  def setup

    @test_data = YAML.load_file TEST_DATA_FILE

    @test_inst = Institution.new('test_sif')

    @users = [ SifUser.new(@test_data['sif_test'], @test_inst) ]

    @xml = Templater.run(@users, @test_inst)


  end

  def test_returns_xml

    assert_kind_of String, @xml

  end

  def test_returns_user_node

    assert_match /<user>/, @xml

  end

  def test_includes_default_epiry_date

    assert_match /2382-12-21Z/, @xml

  end

end