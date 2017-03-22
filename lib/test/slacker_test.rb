require 'minitest/autorun'
require './lib/classes/institution'

class SlackerTest < MiniTest::Test

  def setup

    @inst = Institution.new('test_sif')

  end

  def test_has_a_slacker

    assert_respond_to @inst, :slacker

  end

  def slacker_has_a_critical_error

    assert_respond_to @inst.slacker, :critical_error

  end

  def slacker_has_a_process_completed

    assert_respond_to @inst.slacker, :process_completed

  end

  def slacker_has_a_users_extracted

    assert_respond_to @inst.slacker, :users_extracted

  end

end