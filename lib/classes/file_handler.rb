require 'csv'
require './lib/classes/institution'
require './lib/classes/run_set'
require './lib/classes/file_set'

# this class handles the discovery and classification of files in an
# institution's directory
class FileHandler
  attr_accessor :run_set
  DATA_DIR_BASE = '/gilftpfiles'.freeze
  FILE_DROP_SITE = 'patrondrop'.freeze
  TXT_FILE_FIELD_COUNT = 23
  EXP_DATE_FORMAT = '%Y-%m-%d'.freeze
  VALID_EXP_DATE_TYPES = %w(student facstaff).freeze

  def initialize(institution, run_arguments = [])
    unless institution.is_a? Institution
      fail StandardError, 'Cannot generate for something that is not an Institution!'
    end
    @run_set = RunSet.new
    @run_set.inst = institution
    @run_set.config = parse_arguments run_arguments
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
        add_exp_date_to_fileset file_set, File.basename(file, '.*'), first_line
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

  def parse_arguments(run_arguments)
    run_config = {}
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
      @run_set.inst.logger.error("File read error using CSV.parse_line: #{e.message}")
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

  def add_exp_date_to_fileset(file_set, filename, first_line)
    type = extract_type_from_filename(filename)
    file_set.exp_dates[type.to_sym] = get_expiry_date_from first_line
    file_set
  end

  # expect type to be defined at end of filename
  def extract_type_from_filename(filename)
    final_underscore = filename.rindex('_')
    return false unless final_underscore
    type = filename[(final_underscore + 1)..filename.length]
    if VALID_EXP_DATE_TYPES.include? type
      type
    else
      'all'
    end
  end

end