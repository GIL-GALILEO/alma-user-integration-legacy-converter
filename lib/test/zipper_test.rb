require 'minitest/autorun'
require './lib/classes/zipper'
require './lib/classes/institution'

class XmlFactoryTest < MiniTest::Test

  def setup

    @xml_file = File.open('./temp/text.xml','w')
    @xml_file.puts 'test content'
    @xml_file.close

    @institution = Institution.new 'test_sif'

    @file = Zipper.do(@xml_file, @institution)

  end

  def test_file_is_returned

    assert_kind_of File, @file

  end

  def teardown

    File.delete @file

  end

end