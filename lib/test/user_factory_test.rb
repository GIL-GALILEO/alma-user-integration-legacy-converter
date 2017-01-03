require 'minitest/autorun'
require './lib/classes/institution'
require './lib/classes/user_factory'
require './lib/classes/databaser'
require './lib/classes/run_set'

class UserFactoryTest < MiniTest::Test

  def setup


    @test_inst = Institution.new('test_sif')
    @databaser = Databaser.new @test_inst

    barcode_file = File.new 'data/test_sif/full/barcode_file'
    exp_file     = File.new 'data/test_sif/full/exp_date'
    data_file    = File.new 'data/test_sif/full/student'
    config       = { run_type: :full }

    @run_set = RunSet.new
    @run_set.inst = @test_inst
    @run_set.barcode = barcode_file
    @run_set.data = data_file
    @run_set.exp = exp_file
    @run_set.config = config

  end

  def teardown

    @databaser.truncate_table
    @databaser.close_connection

  end


  def test_error_on_bad_institution

    assert_raises StandardError do
      UserFactory.generate('blah')
    end

  end

  def test_returns_an_array_of_users

    result = UserFactory.generate(@run_set)

    assert_kind_of Array, result
    assert_kind_of SifUser, result[0]

  end

  def test_user_has_barcode_from_file

    result = UserFactory.generate(@run_set)

    assert_equal '87654321930123456', result[0].barcode

  end

  def test_user_has_expiry_date_from_file

    result = UserFactory.generate(@run_set)

    assert_equal '2044-12-20Z', result[0].expiry_date

  end

  def test_user_has_alma_patron_group

    result = UserFactory.generate(@run_set)

    assert_equal 'UNDERGRAD', result[0].user_group

  end

end