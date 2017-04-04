require 'csv'

class RunSet

  attr_reader :config, :inst
  attr_accessor :file_sets

  def initialize
    @data = []
    @file_sets = []
    @config = {}
  end

  def is_sufficient?
    !!(inst && config.any? && file_sets.any?)
  end

  def inst=(inst)
    if inst.is_a? Institution
      @inst = inst
    else
      fail StandardError, 'Institution provided is not an Institution!'
    end
  end

  def config=(config_hash)
    if config_hash.is_a? Hash
      @config = config_hash
    else
      fail StandardError, 'Config value provided is not a Hash!'
    end
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

  def file_exp_date?
    !!@config[:exp_date_from_file]
  end

end