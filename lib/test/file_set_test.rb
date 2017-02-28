require 'minitest/autorun'
require './lib/classes/file_set'

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


end