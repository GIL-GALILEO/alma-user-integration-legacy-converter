require 'csv'

class RunSet

  attr_reader :config, :inst, :file_sets

  def initialize
    @data = []
    @file_sets = []
  end

  def is_sufficient?
    !!(inst && config && @file_sets.any?)
  end

  # the institution object
  def inst=(inst)
    if inst.is_a? Institution
      @inst = inst
    else
      raise StandardError.new('Institution provided is not an Institution!')
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
    @barcode_hash
  end

  def expire?
    !!@config[:expire]
  end

  def dry_run?
    !!@config[:dry_run]
  end

  def sample?
    !!@config[:sample]
  end

  private

  def is_file?(var)
    if var.is_a? File
      true
    else
      raise StandardError.new('Value provided to RunSet is not a File!')
    end
  end

end