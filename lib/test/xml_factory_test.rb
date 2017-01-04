require 'minitest/autorun'
require './lib/classes/xml_factory'
require './lib/classes/institution'
require 'date'

class XmlFactoryTest < MiniTest::Test

  def setup

    @institution = Institution.new('test_sif')

  end

  def test_generate_produces_xml_string

    assert_kind_of String, XmlFactory.generate_for(@institution)

  end

  def test_generate_produces_xml_with_user_node

    assert_match /<user>/, XmlFactory.generate_for(@institution)

  end

  def test_generate_produces_xml_with_expiry_date

    date = (Date.parse(Time.now.to_s) + 180).strftime('%Y-%m-%d')

    assert_match /#{date}Z/, XmlFactory.generate_for(@institution)

  end

  def test_generate_produces_xml_with_barcode

    assert_match /87654321930123456/, XmlFactory.generate_for(@institution)

  end
  
  def test_expire_produces_xml_string

    assert_kind_of String, XmlFactory.expire_for(@institution)

  end

  def test_expire_produces_xml_with_user_node

    assert_match /<user>/, XmlFactory.expire_for(@institution)

  end

  def test_expire_produces_xml_with_today_expiry_date

    date = Date.parse(Time.now.strftime('%Y-%m-%d')).to_s

    assert XmlFactory.expire_for(@institution).index(date)

  end

end