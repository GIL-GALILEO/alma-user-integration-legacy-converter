require 'csv'
require './lib/classes/institution'
require './lib/classes/run_set'
require './lib/classes/file_set'

# this class handles the discovery and classification of files in an
# institution's directory
class FileHandler

  DATA_DIR_BASE = '/gilftpfiles'.freeze
  FILE_DROP_SITE = 'patrondrop'.freeze
  EXPIRE_DIR = 'expire'.freeze

  TXT_FILE_FIELD_COUNT = 23
  EXP_DATE_FORMAT = '%Y-%m-%d'.freeze

  attr_accessor :run_set

  def initialize(institution, run_arguments = [])

    unless institution.is_a? Institution
      fail StandardError, 'Cannot generate for something that is not an Institution!'
    end

    @run_set = RunSet.new
    @run_set.inst = institution
    @run_set.config = set_config_from run_arguments

    institution_root_path = File.join DATA_DIR_BASE, institution.code, FILE_DROP_SITE

    if institution.campuses
      institution.campuses.each do |campus|
        populate_run_set File.join(institution_root_path, campus.path), campus
      end
    else
      populate_run_set institution_root_path
    end

  end

  private

  def populate_run_set(path, campus = nil)

    # if expire flag set, append expire dir to all paths
    path = File.join path, EXPIRE_DIR if @run_set.expire?

    # establish FileSet to handle files from given path
    file_set = FileSet.new
    file_set.campus = campus if campus

    files = get_files_in path

    files.each do |file|

      next if File.directory? file

      begin
        first_line = File.open(file, &:readline)
      rescue StandardError => e
        @run_set.inst.logger.error "File read error: #{e.message}"
        next
      end

      case detect_type_of_file_from(first_line)

      when 'exp_date'
        if file_set.campus
          file_set.exp_date = get_expiry_date_from first_line
        else
          @run_set.config[:exp_date_from_file] = get_expiry_date_from first_line
        end
      when 'barcode'
        file_set.barcodes << file
      when 'patron_sif'
        file_set.patrons << file
      when 'patron_txt'
        file_set.patrons << file
      when 'unknown'
        @run_set.inst.logger.warn "Mystery file encountered: #{file}"
      else
        @run_set.inst.logger.error "File handling error for file: #{file}"

      end

    end

    @run_set.file_sets << file_set if file_set.patrons.any?

  end

  def set_config_from(run_arguments)

    run_config = {}
    run_config[:expire]   = run_arguments.include? 'expire'
    run_config[:dry_run]  = run_arguments.include? 'dry-run'
    run_config[:sample]   = run_arguments.include? 'sample'
    run_config

  end

  def get_files_in(path)

    Dir.glob(File.join(path, '*'))

  end

  def detect_type_of_file_from(line)

    begin
      return 'patron_txt' if CSV.parse_line(line, col_sep: '|', quote_char: "\x00").length == TXT_FILE_FIELD_COUNT
    rescue StandardError => e
      @run_set.inst.logger.error("File read error: #{e.message}")
      return 'unknown'
    end

    case line
    when /2[0-9]{3}[-][0-9]{2}[-][0-9]{2}$/ then 'exp_date'
    when /[0-9"]{9,11}[\,|\t][0-9"]+/ then 'barcode'
    when /.{400,}/ then 'patron_sif'
    else 'unknown'
    end

  end

  def get_expiry_date_from(first_line)
    first_line.strip
  end

end