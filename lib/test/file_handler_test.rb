require 'minitest/autorun'
require './lib/classes/file_handler'
require './lib/classes/institution'
require './lib/classes/run_set'

class FileHandlerTest < MiniTest::Test

  def setup

    @inst = Institution.new('test_sif')
    @fh = FileHandler.new(@inst, [])

  end

  def test_has_a_runset

    assert_kind_of RunSet, @fh.run_set

  end

  def test_a_run_set_with_no_filesets_if_no_files

    assert_equal(
      [],
      FileHandler.new(Institution.new('test_sif_empty'), []).run_set.file_sets
    )

  end

end