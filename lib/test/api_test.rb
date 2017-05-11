require 'minitest/autorun'
require './lib/classes/institution'
require './lib/classes/users/gptc_user'
require './lib/classes/templater'
require './lib/classes/institution'
require './lib/classes/run_set'
require './lib/classes/api'

class ApiTest < MiniTest::Test
  # TEST_DATA_FILE = './config/test_data.yml'.freeze
  #
  # def setup
  #   test_data = YAML.load_file TEST_DATA_FILE
  #   @institution = Institution.new('gptc-api-test')
  #   @user = GptcUser.new test_data['gptc_test'], @institution
  #   @api = Api.new(@institution)
  #   @run_set = RunSet.new
  #   @run_set.inst = @institution
  # end
  #
  # def test_is_connected
  #   assert @api
  # end
  #
  # def test_lookup_user
  #   assert_kind_of AlmaApi::Object, @api.user(@api.client.users.get.first.primary_id)
  # end
  #
  # def test_exists?
  #   assert @api.exists? @api.client.users.get.first.primary_id
  #   assert !@api.exists?('000000000')
  # end
  #
  # def test_create
  #   xml = File.read user_xml
  #   assert @api.create xml
  # end
  #
  # private
  #
  # def user_xml
  #   Templater.run([@user], @run_set)
  # end

end
