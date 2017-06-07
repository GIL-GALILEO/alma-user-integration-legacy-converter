require 'minitest/autorun'
require './lib/classes/file_handler'
require './lib/classes/run_set'
require './lib/classes/file_set'
require './lib/classes/institution'

# tests for basic RunSet functionality
class RunSetTest < MiniTest::Test
  def setup
    @inst = Institution.new('test_sif')
    @config = { sample: true, dry_run: true }
    @file_set = FileSet.new
    @run_set = RunSet.new
    @run_set.inst = @inst
    @run_set.config = @config
    @run_set.file_sets << @file_set
  end

  def test_if_is_sufficient
    assert_equal true, @run_set.sufficient?
  end

  def test_if_no_config
    bad_run_set = RunSet.new
    bad_run_set.inst = @inst
    bad_run_set.file_sets << @file_set
    assert_equal false, bad_run_set.sufficient?
  end

  def test_if_no_institution
    bad_run_set = RunSet.new
    bad_run_set.config = @config
    bad_run_set.file_sets << @file_set
    assert !bad_run_set.sufficient?
  end

  def test_if_no_file_sets
    bad_run_set = RunSet.new
    bad_run_set.inst = @inst
    bad_run_set.config = @config
    assert_equal false, bad_run_set.sufficient?
  end

  def test_is_a_runset
    assert_kind_of RunSet, @run_set
  end

  def test_has_an_institution
    assert_kind_of Institution, @run_set.inst
  end

  def test_has_an_array_of_file_sets
    assert_kind_of Array, @run_set.file_sets
    assert_kind_of FileSet, @run_set.file_sets.first
  end

  def test_has_a_config_hash
    assert_kind_of Hash, @run_set.config
  end

  def test_has_config_hash_methods
    assert @run_set.sample?
    assert @run_set.dry_run?
  end

  def test_error_on_incorrect_types
    assert_raises StandardError do
      RunSet.new.config = :bad
    end
  end
end