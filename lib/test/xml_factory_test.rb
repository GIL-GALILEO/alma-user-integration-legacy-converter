require 'minitest/autorun'
require './lib/classes/xml_factory'
require './lib/classes/institution'
require 'date'

class XmlFactoryTest < MiniTest::Test

  def setup

    @institution = Institution.new('test_sif')

  end

  def test_generate_produces_file

    assert_kind_of File, XmlFactory.generate_for(@institution)

  end

  def test_generate_produces_xml_with_user_node

    assert File.foreach(XmlFactory.generate_for(@institution)).grep /<user>/

  end

  def test_generate_produces_xml_with_expiry_date

    date = (Date.parse(Time.now.to_s) + 180).strftime('%Y-%m-%d')

    assert File.foreach(XmlFactory.generate_for(@institution)).grep /#{date}Z/

  end

  def test_generate_produces_xml_with_barcode

    assert File.foreach(XmlFactory.generate_for(@institution)).grep /87654321930123456/

  end
  
  def test_expire_produces_file

    assert_kind_of File, XmlFactory.expire_for(@institution)

  end

  def test_expire_produces_xml_with_user_node

    assert File.foreach(XmlFactory.expire_for(@institution)).grep /<user>/

  end

  def test_expire_produces_xml_with_today_expiry_date

    date = Date.parse(Time.now.strftime('%Y-%m-%d')).to_s

    assert File.foreach(XmlFactory.expire_for(@institution)).grep(date)

  end

end