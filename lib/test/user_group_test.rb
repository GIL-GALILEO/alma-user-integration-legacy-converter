require 'minitest/autorun'
require './lib/classes/user_group'
require './lib/classes/institution'

# tests for UserGroup functionality
class UserGroupTest < MiniTest::Test
  def setup
    @inst = Institution.new('test_sif_facstaff')
    campus = nil
    @user_group = UserGroup.new(@inst, campus, 'STAFF')
  end

  def test_to_s_returns_alma_name
    assert_equal 'ALMA STAFF', @user_group.to_s
  end

  def test_alma_name_returns_alma_name
    assert_equal 'ALMA STAFF', @user_group.alma_name
  end

  def test_alma_name_returns_banner_name
    assert_equal 'STAFF', @user_group.banner_name
  end

  def test_weight_returns_integer_weight
    assert_equal 9, @user_group.weight
    assert_kind_of Integer, @user_group.weight
  end

  def test_institution_returns_institution
    assert_equal @inst, @user_group.institution
  end

  def test_is_heavier_than_returns_true_when_appropriate
    other_user_group = UserGroup.new(@inst, nil, 'UNDERGRAD')
    assert @user_group.heavier_than? other_user_group
  end

  def test_is_heavier_than_returns_false_when_appropriate
    other_user_group = UserGroup.new(@inst, nil, 'FACULTY')
    assert !@user_group.heavier_than?(other_user_group)
  end

  def test_unknown_banner_name_raises_error
    assert_raises StandardError do
      UserGroup.new(@inst, 'DOESNT EXIST')
    end
  end

  def test_user_group_has_a_type
    assert_equal @user_group.type, 'facstaff'
  end

  def test_user_group_type_booleans
    assert @user_group.facstaff?
    assert !@user_group.student?
  end

  def test_grad_student_outweighs_staff
    inst = Institution.new('uga')
    user_group = UserGroup.new inst, nil, nil, %w(00 03 02), 'G'
    assert_equal 'GRAD PRIV', user_group.alma_name
  end

  def test_student_group_for_student_employees
    inst = Institution.new('uga')
    assert_equal(
      'UNDER PRIV',
      UserGroup.new(inst, nil, nil, %w(00 02), 'U').alma_name
    )
    assert_equal(
      'GRAD PRIV',
      UserGroup.new(inst, nil, nil, %w(00 02), 'G').alma_name
    )
    assert_equal(
      'UNDER PRIV',
      UserGroup.new(inst, nil, nil, %w(02 65), 'U').alma_name
    )
    assert_equal(
      'GRAD PRIV',
      UserGroup.new(inst, nil, nil, %w(02 10), 'U').alma_name
    )
  end
end