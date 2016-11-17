require 'minitest/autorun'
require './lib/classes/xml_factory'
require './lib/classes/institution'

class XmlFactoryTest < MiniTest::Test

  def setup

    # @xml_factory_sif_result = XmlFactory.generate_for(Institution.new('test_sif')) # usingthis would cause tests to fail when run as a group, very strange
    # @xml_factory_txt_result = XmlFactory.generate_for(Institution.new('test_txt'))

  end

  def test_sif_produces_xml_string

    # assert_kind_of String, @xml_factory_sif_result
    assert_kind_of String, XmlFactory.generate_for(Institution.new('test_sif'))

  end

  def test_sif_produces_xml_with_user_node

    assert_match /<user>/, XmlFactory.generate_for(Institution.new('test_sif'))

  end

  def test_sif_produces_xml_with_expiry_date

    assert_match /2044-12-20Z/, XmlFactory.generate_for(Institution.new('test_sif'))

  end

  def test_sif_produces_xml_with_barcode

    assert_match /87654321930123456/, XmlFactory.generate_for(Institution.new('test_sif'))

  end

end