require 'minitest/autorun'
require './lib/classes/xml_factory'

class XmlFactoryTest < MiniTest::Test

  def setup

    @xml_factory_sif_result = XmlFactory.generate_for 'test_sif'
    # @xml_factory_txt_result = XmlFactory.generate_for 'test_txt'

  end

  def test_sif_produces_xml_string

    assert_kind_of String, @xml_factory_sif_result

  end

  def test_sif_produces_xml_with_user_node

    assert_match /<user>/, @xml_factory_sif_result

  end

  def test_sif_produces_xml_with_expiry_date

    assert_match /2044-12-20Z/, @xml_factory_sif_result

  end

  def test_sif_produces_xml_with_barcode

    assert_match /87654321930123456/, @xml_factory_sif_result

  end

end