require 'minitest/autorun'
require './lib/classes/file_set'
require './lib/classes/campus'
require './lib/classes/institution'

class FileSetTest < MiniTest::Test

  def setup

    barcode_file = File.new '/gilftpfiles/test_sif/patrondrop/barcode_file'
    patron_file   = File.new '/gilftpfiles/test_sif/patrondrop/student'

    @file_set = FileSet.new
    @file_set.patrons << patron_file
    @file_set.barcodes << barcode_file

  end

  def test_has_patron_files

    assert_kind_of Array, @file_set.patrons
    assert_kind_of File, @file_set.patrons.first

  end

  def test_has_barcode_files

    assert_kind_of Array, @file_set.barcodes
    assert_kind_of File, @file_set.barcodes.first

  end

  def test_can_hold_barcode_hash

    @file_set.barcodes_hash = {}

    assert @file_set.barcodes_hash

  end

  def test_can_have_campus

    assert_nil @file_set.campus

    campus = Campus.new(Institution.new('test_sif'))
    @file_set.campus = campus

    assert @file_set.campus

  end

end