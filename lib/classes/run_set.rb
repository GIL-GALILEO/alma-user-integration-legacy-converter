require 'csv'

class RunSet

  attr_reader :data, :barcode, :config, :inst

  def initialize
    @data = []
  end

  def is_sufficient?
    !!(inst && data && config)
  end

  # the institution object
  def inst=(inst)
    if inst.is_a? Institution
      @inst = inst
    else
      raise StandardError.new('Institution provided is not an Institution!')
    end
  end

  def add_data(data_file)

    if is_file? data_file
      @data << data_file
    else
      raise StandardError.new('Data file provided is not a File!')
    end

  end

  # the patron or facstaff file
  def data=(data_file)
    if is_file? data_file
      @data << data_file
    else
      raise StandardError.new('Data file provided is not a File!')
    end
  end

  # the expiration date file, if provided
  def exp=(exp_file)
    if is_file? exp_file
      @exp = exp_file
    else
      raise StandardError.new('Exp Date file provided is not a File!')
    end
  end

  # the barcode file, if provided
  def barcode=(barcode_file)
    if is_file? barcode_file
      @barcode = barcode_file
    else
      raise StandardError.new('Barcode file provided is not a File!')
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

  def barcode_hash
    if inst.expect_barcodes? and @barcode
      barcode_array = CSV.read(@barcode.path, col_sep: '|')
      Hash[*barcode_array.flatten]
    else
      nil
    end
  end

  private

  def is_file?(var)
    if var.is_a? File
      true
    else
      raise StandardError.new('Value provided to FileSet is not a File!') # todo just return false and handle errors elsewhere
    end
  end

end