require 'minitest/autorun'
require './lib/classes/file_handler'
require './lib/classes/run_set'
require './lib/classes/file_set'
require './lib/classes/institution'

class RunSetTest < MiniTest::Test

  def setup

    inst = Institution.new('test_sif')

    config       = {
        run_type: :full, # todo deprecated?
        sample: true,
        expire: true,
        dry_run: true
    }

    @run_set = RunSet.new
    @run_set.inst = inst
    @run_set.config = config
    @run_set.file_sets << FileSet.new

  end

  def test_returns_true_if_is_sufficient

    assert_equal true, @run_set.is_sufficient?

  end

  def test_returns_false_if_not_sufficient

    bad_run_set = RunSet.new

    assert_equal false, bad_run_set.is_sufficient?

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

  def test_has_a_config_hash_value

    assert_equal :full, @run_set.config[:run_type]

  end

  def test_raises_error_on_incorrect_types

    run_set = RunSet.new

    assert_raises StandardError do
      run_set.config = :bad
    end

  end

  def test_responds_boolean_to_expire?

    assert @run_set.expire?

  end

  def test_responds_boolean_to_dry_run?

    assert @run_set.dry_run?

  end

  def test_responds_boolean_to_sample?

    assert @run_set.sample?

  end

end