require 'minitest/autorun'
require './lib/classes/institution'
require './lib/classes/user_factory'
require './lib/classes/file_handler'
require './lib/classes/file_set'

class UserFactoryTest < MiniTest::Test

  def setup

    @test_inst = Institution.new('test_sif')
    @run_set = FileHandler.new(@test_inst).run_set
    @result = UserFactory.generate(@run_set)
    @alma_user_groups = @result.map(&:user_group).map(&:alma_name)

  end

  def test_error_on_bad_institution

    assert_raises StandardError do
      UserFactory.generate('blah')
    end

  end

  def test_returns_an_array_of_users

    assert_kind_of Array, @result
    assert_kind_of SifUser, @result[0]

  end

  def test_user_has_barcode_from_file

    barcode_user = nil
    @result.each do |user|
      barcode_user = user if user.barcode
    end

    assert_equal '87654321930123456', barcode_user.barcode

  end

  def test_result_has_alma_patron_group


    assert_includes @alma_user_groups, 'ALMA STUDENT'

  end

  def test_users_with_no_group_are_given_default

      assert_equal 3, @result.size
      assert_includes @alma_user_groups, 'TEST DEFAULT'

  end

  def test_duplicate_user_entries_take_the_role_with_highest_weight

    patron_file = File.new '/gilftpfiles/test_sif_facstaff/patrondrop/test_sif.txt'

    file_set = FileSet.new
    file_set.patrons << patron_file

    @run_set.file_sets << file_set

    result = UserFactory.generate(@run_set)
    alma_user_groups = result.map(&:user_group).map(&:alma_name)

    assert_includes  alma_user_groups, 'ALMA STAFF'

  end

end