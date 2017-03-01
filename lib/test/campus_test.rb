require 'minitest/autorun'
require './lib/classes/run_set'
require './lib/classes/institution'

class CampusTest < MiniTest::Test

  def setup

    @no_campuses_institution = Institution.new('test_sif')
    @institution = Institution.new('test_multi_campus')

  end

  def test_has_institution

    assert_kind_of Institution, @institution.campuses.first.institution

  end

  def test_has_no_campuses

    assert_nil @no_campuses_institution.campuses

  end

  def test_has_array_of_campuses

    assert_kind_of Array, @institution.campuses
    assert_kind_of Campus, @institution.campuses.first

  end

  def test_has_settings

    campus = @institution.campuses.first

    assert_equal 'campus1', campus.name
    assert_equal 'sif_campus1_user', campus.user_class
    assert_equal 'campus1', campus.path
    assert campus.barcodes
    assert_equal '|', campus.barcode_separator

  end

end