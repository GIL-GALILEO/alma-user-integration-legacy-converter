require 'minitest/autorun'
require './lib/classes/file_handler'
require './lib/classes/run_set'

class RunSetTest < MiniTest::Test

  def setup

    barcode_file = File.new 'data/test_sif/full/barcode_file'
    exp_file     = File.new 'data/test_sif/full/exp_date'
    data_file    = File.new 'data/test_sif/full/student'
    config       = { run_type: :full }

    @run_set = RunSet.new
    @run_set.barcode = barcode_file
    @run_set.data = data_file
    @run_set.exp = exp_file
    @run_set.config = config

  end

  def test_is_a_runset

    assert_kind_of RunSet, @run_set

  end

  def test_has_a_barcode_file

    assert_kind_of File, @run_set.barcode

  end

  def test_has_a_data_file

    assert_kind_of File, @run_set.data

  end

  def test_has_a_exp_date_file

    assert_kind_of File, @run_set.exp

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
      run_set.data = 'bad'
    end

    assert_raises StandardError do
      run_set.config = :bad
    end

  end

end