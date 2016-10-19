require 'minitest/autorun'
require 'yaml'
require './lib/objects/institution'

class InstitutionTest < MiniTest::Test

  def setup

    @inst = Institution.new('test_sif', true)

  end

  def test_error_on_missing_config

    assert_raises StandardError do
      Institution.new('zoia', true)
    end

  end

  def test_has_code

    assert_equal @inst.code, 'test_sif'

  end

  def test_has_logger

    assert_kind_of Logger, @inst.logger

  end

  def test_has_groups_data_hash

    assert_kind_of Hash, @inst.groups_data

  end

  def test_has_boolean_methods

    bools = [true, false]

    assert_includes bools, @inst.expect_sif?
    assert_includes bools, @inst.expect_txt?
    assert_includes bools, @inst.expect_combined?
    assert_includes bools, @inst.expect_barcodes?
    assert_includes bools, @inst.expect_exp_date?

  end

end