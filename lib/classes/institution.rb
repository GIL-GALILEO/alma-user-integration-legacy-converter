require 'yaml'
require 'logger'
require './lib/classes/campus'
require './lib/classes/mailer'
require './lib/classes/slacker'
require './lib/classes/user_group'

class Institution

  INSTITUTION_CONFIG_FILE       = './config/inst.yml'.freeze
  INSTITUTION_DATA_PATH         = '/gilftpfiles/'.freeze
  INSTITUTION_LOGS_PATH         = '/gilftpfiles/logs/'.freeze
  FILE_DROP_SITE                = 'patrondrop'.freeze

  attr_accessor :campuses
  attr_reader :mailer, :slacker, :code, :apikey

  def initialize(code)

    @code = code
    inst_configs = YAML.load_file(INSTITUTION_CONFIG_FILE)
    @config = inst_configs[@code]
    unless @config
      fail StandardError, "Institution config could not be loaded for #{@code}"
    end

    # set campuses
    if @config['campus']
      @campuses = []
      @config['campus'].each do |campus_data|
        @campuses << Campus.new(self, campus_data)
      end
    else
      @campuses = nil
    end

    set_logger
    @apikey = @config['api-key']
    @slacker = Slacker.new self
    @mailer = Mailer.new self

  end

  def logger
    @institution_logger
  end

  def alma_archive_path
    File.join INSTITUTION_DATA_PATH, code, 'archive'
  end

  def raw_archive_path
    File.join alma_archive_path, 'raw'
  end

  def user_class
    @config['user_class_file']
  end

  def barcode_separator
    @config['barcode_separator']
  end

  def notification_emails
    @config['notification_emails'] ? @config['notification_emails'] : []
  end

  def groups_data
    @config['user_group_conversion'] ? @config['user_group_conversion'] : {}
  end

  def groups_settings
    @config['user_group_settings'] ? @config['user_group_settings'] : {}
  end

  def expect_barcodes?
    !!@config['barcodes']
  end

  private

  def set_logger
    retries = 2
    begin
      @institution_logger = Logger.new "#{INSTITUTION_LOGS_PATH}#{code}_log.log"
    rescue StandardError => e
      sleep 1
      retries -= 1
      retry if retries > 0
    end
  end
end