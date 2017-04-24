# this class represents a set of files and configuration for a campus or
# institution
class FileSet

  attr_accessor :barcodes, :patrons, :barcodes_hash, :campus, :exp_dates

  def initialize

    self.barcodes = []
    self.patrons = []
    self.barcodes_hash = {}
    self.campus = nil
    self.exp_dates = {}

  end

end