class FileSet

  attr_accessor :barcodes, :patrons, :barcodes_hash, :campus, :exp_date

  def initialize

    self.barcodes = []
    self.patrons = []
    self.barcodes_hash = {}
    self.campus = nil
    self.exp_date = nil

  end

end