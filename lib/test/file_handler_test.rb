require 'minitest/autorun'
require './lib/classes/file_handler'
require './lib/classes/institution'
require './lib/classes/run_set'

# tests for FileHandler class functionality with basic setup
class FileHandlerBasicTest < MiniTest::Test
  def setup
    @inst = Institution.new 'test_sif'
    @run_set = FileHandler.new(@inst).run_set
  end

  def test_has_a_runset
    assert_kind_of RunSet, @run_set
  end

  def test_produces_file_sets
    assert_kind_of Array, @run_set.file_sets
    assert_kind_of FileSet, @run_set.file_sets.first
  end

  def test_file_set_has_patron_and_barcode
    file_set = @run_set.file_sets.first
    assert file_set.patrons.any?
    assert file_set.barcodes.any?
    assert_nil file_set.campus
  end

  def test_param_handling
    params = %w(
      expire
      sample
      dry-run
    )
    run_set = FileHandler.new(@inst, params).run_set
    assert run_set.expire?
    assert run_set.sample?
    assert run_set.dry_run?
  end
end

# tests for FileHandler class functionality with complex setup (e.g. multiple
# patron files, exp_dates, barcodes, etc.)
class FileHandlerComplexTest < MiniTest::Test
  def setup; end

  def test_multi_campus_institution
    multi_campus_inst = Institution.new 'test_multi_campus'
    multi_campus_run_set = FileHandler.new(multi_campus_inst).run_set
    file_set = multi_campus_run_set.file_sets.first
    assert file_set.campus
    assert_equal '2017-01-01', file_set.exp_dates[:all]
  end

  def test_no_files_case
    assert(
      FileHandler.new(
        Institution.new('test_sif_empty')
      ).run_set.file_sets.empty?
    )
  end

  def test_exp_dates_override
    inst = Institution.new 'test_exp_override'
    file_set = FileHandler.new(inst).run_set.file_sets.first
    assert_equal file_set.exp_dates[:all], '2017-01-01'
  end

  def test_multi_exp_date_override
    inst = Institution.new 'test_sif_facstaff'
    file_set = FileHandler.new(inst).run_set.file_sets.first
    assert_nil file_set.exp_dates[:all]
    assert_equal file_set.exp_dates[:student], '2017-09-01'
    assert_equal file_set.exp_dates[:facstaff], '2018-01-01'
  end
end