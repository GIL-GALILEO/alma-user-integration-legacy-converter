require 'minitest/autorun'
require './lib/classes/xml_factory'
require './lib/classes/file_handler'
require 'date'
require 'nokogiri'
include Util::App

# common functionality for RealTest classes
class BaseRealTest < MiniTest::Test
  DATA_FILES_PATH = '/gilftpfiles'.freeze
  def setup
  end

  def join(*paths)
    File.join paths
  end

  def test_setup
    assert_equal DATA_FILES_PATH, '/gilftpfiles'
    assert File.directory? DATA_FILES_PATH
  end

  def find_users(document, xml_field, field_value)
    search_value = if field_value.is_a?(Integer) || !/\A\d+\z/.match(field_value)
                     "'#{field_value}'"
                   else
                     field_value
                   end
    document.xpath(
      "//users/user/#{xml_field}[normalize-space(text())=#{search_value}]"
    ).map(&:parent)
  end

  def find_user(document, xml_field, field_value)
    find_users(document, xml_field, field_value).first
  end

  def user_value(user_node, field)
    user_node.css(field).inner_text
  end
end