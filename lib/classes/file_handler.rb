require 'csv'
require './lib/classes/institution'
require './lib/classes/run_set'

class FileHandler

  DATA_DIR_BASE = '/gilftpfiles'
  FILE_DROP_SITE = 'patrondrop'
  EXPIRE_DIR = 'expire'

  TXT_FILE_FIELD_COUNT = 23

  def initialize(institution)

    unless institution.is_a? Institution
      raise StandardError.new('Cannot generate for something that is not an Institution!')
    end

    if institution.path && institution.parent_inst
      @inst_files_root = File.join DATA_DIR_BASE, institution.parent_inst.code, FILE_DROP_SITE, institution.path
    elsif institution.path
      @inst_files_root = File.join DATA_DIR_BASE, institution.code, FILE_DROP_SITE, institution.path
    else
      @inst_files_root = File.join DATA_DIR_BASE, institution.code, FILE_DROP_SITE
    end

    @institution = institution

  end

  def generate(config = {})

    run_config = {}

    if config.has_key?(:expire) and config[:expire]
      run_config[:run_type] = :expire
      drop_location = File.join @inst_files_root, EXPIRE_DIR, '*'
    else
      run_config[:run_type] = :add
      drop_location = File.join @inst_files_root, '*'
    end

    files = get_files_in drop_location

    if files.empty?
      nil
    else
      compose_runset(files, run_config)
    end

  end

  private

  def compose_runset(files, run_config)

    return nil unless files

    run_set = RunSet.new
    run_set.inst = @institution

    files.each do |file_path|

      begin
        file_first_line = File.open(file_path, &:readline)
      rescue StandardError => e
        @institution.logger.error("File read error: #{e.message}")
        next
      end

      case detect_type_of_file(file_first_line)

        when 'barcode'

          run_set.barcode = File.new file_path

        when 'patron_sif'

          run_set.add_data File.new(file_path)

        when 'patron_txt'

          run_set.add_data File.new(file_path)

        when 'unknown'

          @institution.logger.warn("Mystery file encountered: #{file_path}")

        else

          @institution.logger.error("File handling error for file: #{file_path}")

      end

    end
      
    run_set.config = run_config

    run_set

  end

  def get_files_in(path)
    Dir.glob path
  end

  def detect_type_of_file(line)

    begin
      if CSV.parse_line(line, col_sep: '|' ).length == TXT_FILE_FIELD_COUNT
        return 'patron_txt'
      end
    rescue StandardError => e
      @institution.logger.error("File read error for file #{file_path}: #{e.message}")
      return 'unknown'
    end

    case line

      # when /2[0-9]{3}[-][0-9]{2}[-][0-9]{2}$/ then 'exp_date'
      when /[0-9"]{9,11}[\,|\t][0-9"]+/ then 'barcode'
      when /.{400,}/ then 'patron_sif'
      else 'unknown'

    end

  end

end