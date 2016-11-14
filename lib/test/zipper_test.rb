require 'minitest/autorun'
require './lib/classes/zipper'
require './lib/classes/institution'

class XmlFactoryTest < MiniTest::Test

  def setup

    @string = 'anything'
    @institution = Institution.new 'test_sif'

    @file = Zipper.do(@string, @institution)

  end

  def test_file_is_returned

    assert_kind_of File, @file

  end

  def test_file_has_proper_name

    assert_match "alma_xml_#{Time.now.strftime('%Y%m%d_%H%M%S')}.zip", @file.path

  end

  def teardown

    File.delete @file

  end

end