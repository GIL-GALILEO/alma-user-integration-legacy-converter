require 'minitest/autorun'
require 'yaml'
require './lib/classes/sif_user'
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

  def test_expire_record_fields

    user = User.new
    user.primary_id = '123456789'
    user.expiry_date = '1-1-2000Z'

    users = [ user ]

    xml = Templater.run users, @test_inst

    assert_match /<primary_id>/, xml
    assert_match /<primary_id>/, xml
    assert !(xml =~ /<middle_name>/)

  end

  def test_only_include_node_if_present

    users = [ SifUser.new(@test_data['sif_test'], @test_inst) ]

    users[0].middle_name = nil

    xml = Templater.run(users, @test_inst)

    assert !(xml =~ /<middle_name>/)

  end


  def test_users_of_two_different_classes_in_same_xml

    user = User.new
    user.primary_id = '123456789'
    user.expiry_date = '1-1-2000Z'

    users = [
        SifUser.new(@test_data['sif_test'], @test_inst),
        user
    ]

    xml = Templater.run(users, @test_inst)

    assert_equal xml.scan(/<primary_id>/).length, 2
    assert_equal xml.scan(/<first_name>/).length, 1

  end

end