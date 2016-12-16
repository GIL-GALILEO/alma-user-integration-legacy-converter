require 'yaml'
require 'logger'

class Institution

  INSTITUTION_CONFIG_FILE       = './config/inst.yml'
  INSTITUTION_DATA_PATH         = './data/'

  def initialize(code)

    @code = code
    inst_configs = YAML.load_file(INSTITUTION_CONFIG_FILE)
    @config = inst_configs[@code]
    unless @config
      raise StandardError.new("Institution config could not be loaded for #{@code}")
    end

    log_path = "#{INSTITUTION_DATA_PATH}#{code}/log.log"

    @institution_logger = Logger.new log_path

  end

  def logger
    @institution_logger
  end

  def code
    @code
  end

  def groups_data
    @config['user_group_conversion']
  end

  def expect_sif?
    @config['file_type'] == 'sif'
  end

  def expect_txt?
    @config['file_type'] == 'txt'
  end

  def user_class
    @config['user_class_file']
  end

  def process_facstaff?
    !@config['fac_staff'] == 'manual'
  end

  def expect_mixed?
    @config['fac_staff'] == 'mixed'
  end

  def expect_barcodes?
    !!@config['barcodes']
  end

  def expect_exp_date?
    !!@config['exp_date']
  end

  def autoexpire_missing_users?
    !!@config['expire_users']
  end

end