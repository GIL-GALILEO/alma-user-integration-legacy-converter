class Campus

  attr_accessor :name, :path, :class, :barcodes, :barcode_separator, :institution

  def initialize(institution, settings = {})

    self.institution = institution

    begin
      self.name = settings[0]
      self.path = settings[1]['path']
      self.class = settings[1]['user_class_file']
      if settings[1]['barcodes']
        self.barcodes = settings[1]['barcodes']
        self.barcode_separator = settings[1]['barcode_separator']
      end
    rescue StandardError => e
      msg = "Error creating XML for User on row #{row}: #{e.message}"
      institution.logger.error msg
      institution.mailer.add_script_error_message msg

    end

  end

  def barcodes?
    !!barcodes
  end

end
