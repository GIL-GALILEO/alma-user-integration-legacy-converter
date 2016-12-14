require 'minitest/autorun'
require './lib/classes/file_handler'
require './lib/classes/institution'
require './lib/classes/run_set'

class FileHandlerTest < MiniTest::Test

  def setup

    @inst = Institution.new('test_sif')
    @fh = FileHandler.new(@inst)

  end

  def test_returns_a_runset

    assert_kind_of RunSet, @fh.generate

  end

end