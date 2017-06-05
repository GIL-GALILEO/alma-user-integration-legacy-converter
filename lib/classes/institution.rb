require 'yaml'
require 'logger'
require './lib/classes/campus'
require './lib/classes/mailer'
require './lib/classes/slacker'
require './lib/classes/user_group'

class Institution

  INSTITUTION_CONFIG_FILE       = './config/inst.yml'.freeze
  INSTITUTION_DATA_PATH         = '/gilftpfiles/'.freeze
  FILE_DROP_SITE                = 'patrondrop'.freeze

  attr_accessor :campuses
  attr_reader :mailer, :slacker, :code, :apikey

  def initialize(code)

    @code = code
    inst_configs = YAML.load_file(INSTITUTION_CONFIG_FILE)
    @config = inst_configs[@code]
    unless @config
      raise StandardError.new("Institution config could not be loaded for #{@code}")
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

    @apikey = @config['api-key']
    @institution_logger = Logger.new "#{INSTITUTION_DATA_PATH}#{code}/#{code}_log.log"
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

  def unprocessed_file?
    institution_root_path = File.join INSTITUTION_DATA_PATH, code, FILE_DROP_SITE
    if campuses
      campuses.each do |campus|
        files_path = File.join(institution_root_path, campus.path)
        return true if important_file? files_path
      end
    else
      files_path = institution_root_path
      return true if important_file? files_path
    end
    false
  end

  private

  def important_file?(path)
    ignore_files = %w(exp_date exp_date_student exp_date_facstaff log)
    files = Dir.glob(File.join(path, '*'))
    files.each do |file|
      ext = File.extname(file)
      filename = if ext.empty?
                   File.basename file
                 else
                   File.basename(file, ext)
                 end
      next if ignore_files.include? filename
      next if filename.include? 'barcode'
      return true
    end
    false
  end
end