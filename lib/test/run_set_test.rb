require 'minitest/autorun'
require './lib/classes/file_handler'
require './lib/classes/run_set'
require './lib/classes/institution'

class RunSetTest < MiniTest::Test

  def setup

    inst = Institution.new('test_sif')

    barcode_file = File.new '/gilftpfiles/test_sif/patrondrop/barcode_file'
    data_file    = File.new '/gilftpfiles/test_sif/patrondrop/student'
    config       = { run_type: :full }

    @run_set = RunSet.new
    @run_set.inst = inst
    @run_set.barcode = barcode_file
    @run_set.data = data_file
    @run_set.config = config

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

  def test_has_a_barcode_file

    assert_kind_of File, @run_set.barcode

  end

  def test_has_a_data_file_array

    assert_kind_of Array, @run_set.data

  end

  def test_can_have_two_data_files

    @run_set.add_data File.new('/gilftpfiles/test_sif/patrondrop/student_dni')

    assert_kind_of Array, @run_set.data

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