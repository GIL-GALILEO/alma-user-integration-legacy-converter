class Campus

  attr_accessor :name, :code, :path, :user_class, :barcodes, :barcode_separator, :institution, :groups_settings

  def initialize(institution, settings = {})

    self.institution = institution

    begin
      self.name = settings[0]
      self.path = settings[1]['path']
      self.code = settings[1]['code']
      self.user_class = settings[1]['user_class_file']
      self.groups_settings = settings[1]['user_group_settings']
      if settings[1]['barcodes']
        self.barcodes = settings[1]['barcodes']
        self.barcode_separator = settings[1]['barcode_separator']
      end
    rescue StandardError => e
      msg = "Error creating Campus (#{name}) for Institution (#{institution.code}): #{e.message}"
      institution.logger.error msg
      institution.mailer.add_script_error_message msg
    end

  end

  def barcodes?
    !!barcodes
  end

end
