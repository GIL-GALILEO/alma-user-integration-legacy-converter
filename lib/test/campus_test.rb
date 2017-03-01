require 'minitest/autorun'
require './lib/classes/institution'

class CampusTest < MiniTest::Test

  def setup

    @no_campuses_institution = Institution.new('test_sif')
    @institution = Institution.new('test_multi_campus')

    @campus = @institution.campuses.first

  end

  def test_has_institution

    assert_kind_of Institution, @campus.institution

  end

  def test_has_no_campuses

    assert_nil @no_campuses_institution.campuses

  end

  def test_has_array_of_campuses

    assert_kind_of Array, @institution.campuses
    assert_kind_of Campus, @campus

  end

  def test_has_settings

    assert @campus.barcodes
    assert_equal 'campus1', @campus.name
    assert_equal 'sif_user', @campus.user_class
    assert_equal 'campus1', @campus.path
    assert_equal '|', @campus.barcode_separator

  end

  def test_has_user_group_settings

    assert_kind_of Hash, @campus.user_group_settings
    assert @campus.user_group_settings.any?

  end

end