class RunSet

  attr_reader :data, :exp, :barcode, :config

  # the patron or facstaff file
  def data=(data_file)
    if is_file? data_file
      @data = data_file
    end
  end

  # the expiration date file, if provided
  def exp=(exp_file)
    if is_file? exp_file
      @exp = exp_file
    end
  end

  # the barcode file, if provided
  def barcode=(barcode_file)
    if is_file? barcode_file
      @barcode = barcode_file
    end
  end

  # a config Hash
  def config=(config_hash)
    if config_hash.is_a? Hash
      @config = config_hash
    else
      raise StandardError.new('Config value provided is not a Hash!')
    end
  end

  private

  def is_file?(var)
    if var.is_a? File
      true
    else
      raise StandardError.new('Value provided to FileSet is not a File!')
    end
  end

end