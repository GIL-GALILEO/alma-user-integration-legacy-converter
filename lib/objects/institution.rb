class Institution

  INSTITUTION_CONFIG_FILE   = './config/inst.yml'
  INSTITUTION_DATA_PATH     = './data/real/'

  def initialize(code)

    @code = code
    inst_configs  = YAML.load_file INSTITUTION_CONFIG_FILE
    @config = inst_configs[@code]
    unless @config
      raise StandardError.new("Institution config could not be loaded for #{@code}")
    end

  end

  def code
    @code
  end

end