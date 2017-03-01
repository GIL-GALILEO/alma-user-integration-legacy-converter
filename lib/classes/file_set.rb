class FileSet

  attr_accessor :barcodes, :patrons, :barcodes_hash, :campus

  def initialize

    self.barcodes = []
    self.patrons = []
    self.barcodes_hash = {}
    self.campus = nil

  end

end