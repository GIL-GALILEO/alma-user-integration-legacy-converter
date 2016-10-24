require 'minitest/autorun'
require './lib/objects/xml_factory'

class XmlFactoryTest < MiniTest::Test

  def setup

    @xml_factory_sif_result = XmlFactory.generate_for 'test_sif'
    # @xml_factory_txt_result = XmlFactory.generate_for 'test_txt'

  end

  def test_sif_produces_xml_string

    assert_match /<user>/, @xml_factory_sif_result

  end

end