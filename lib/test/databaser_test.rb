require 'minitest/autorun'
require './lib/classes/databaser'

class DatabaserTest < MiniTest::Test

  def setup

    @databaser = Databaser.new('test_sif')

  end

  def teardown

    @databaser.truncate_table
    @databaser.close_connection

  end

  def test_table_can_be_truncated

    @databaser.add_user_to_archive '123456789'
    @databaser.truncate_table

    assert !@databaser.is_user_in_archive('123456789')

  end

  def test_user_exists_when_added

    @databaser.add_user_to_archive '123456789'

    assert @databaser.is_user_in_archive('123456789')

  end

  def test_get_all_users

    @databaser.add_user_to_archive '111111111'
    @databaser.add_user_to_archive '222222222'

    assert_equal %w(111111111 222222222), @databaser.all_users_from_previous_load

  end

end