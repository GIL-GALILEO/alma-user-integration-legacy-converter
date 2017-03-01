require 'minitest/autorun'
require './lib/classes/institution'
require './lib/classes/user_factory'
require './lib/classes/run_set'

class UserFactoryTest < MiniTest::Test

  def setup

    @test_inst = Institution.new('test_sif')

    config        = { run_type: :full }

    @run_set = RunSet.new
    @run_set.inst = @test_inst
    @run_set.config = config

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

  def test_user_has_alma_patron_group

    result = UserFactory.generate(@run_set)

    assert_equal 'ALMA STUDENT', result[0].user_group.alma_name

  end

  def test_users_with_no_group_are_given_default

      result = UserFactory.generate(@run_set)

      assert_equal 2, result.size
      assert_equal 'DEFAULT', result[1].user_group.alma_name

  end

  def test_users_from_both_files_are_included

    assert_equal 'Alma', UserFactory.generate(@run_set)[0].first_name
    assert_equal 'Other', UserFactory.generate(@run_set)[1].first_name

  end

  def test_duplicate_user_entries_take_the_role_with_highest_weight

    inst = Institution.new('test_sif_facstaff')

    file = File.new '/gilftpfiles/test_sif_facstaff/patrondrop/test_sif.txt'

    run_set = RunSet.new
    run_set.inst = inst
    run_set.config = { run_type: :full }
    run_set.data = file

    assert_equal 'ALMA STAFF', UserFactory.generate(run_set)[0].user_group_for_alma

  end

end