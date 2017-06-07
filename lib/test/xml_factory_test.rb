require 'minitest/autorun'
require './lib/classes/xml_factory'
require './lib/classes/institution'
require './lib/classes/file_handler'
require 'date'

class XmlFactoryTest < MiniTest::Test

  def setup

    @institution = Institution.new 'test_sif'
    @run_set = FileHandler.new(@institution, []).run_set
    @expire_run_set = FileHandler.new(@institution, ['expire']).run_set

  end

  def test_generate_produces_file

    assert_kind_of File, XmlFactory.get_result(@run_set)

  end

  def test_generate_produces_xml_with_user_node

    assert File.foreach(XmlFactory.get_result(@run_set)).grep /<user>/

  end

  def test_generate_produces_xml_with_expiry_date

    date = (Date.parse(Time.now.to_s) + 180).strftime('%Y-%m-%d')

    assert File.foreach(XmlFactory.get_result(@run_set)).grep /#{date}Z/

  end

  def test_generate_produces_xml_with_barcode

    assert File.foreach(XmlFactory.get_result(@run_set)).grep /87654321930123456/

  end

  def test_generate_produces_xml_with_primary_phone

    assert File.foreach(XmlFactory.get_result(@run_set)).grep /(111)222-3333/

  end

  def test_generate_produces_xml_with_secondary_phone

    assert File.foreach(XmlFactory.get_result(@run_set)).grep /(123)456-7890/

  end

end