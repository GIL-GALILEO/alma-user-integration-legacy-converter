require 'csv'
require './lib/classes/institution'
require './lib/classes/run_set'

class FileHandler

  DATA_DIR_BASE = './data/'
  TXT_FILE_FIELD_COUNT = 23

  EXPIRE_DIR = 'expire'

  def initialize(institution)

    unless institution.is_a? Institution
      raise StandardError.new('Cannot generate for something that is not an Institution!')
    end

    @inst_files_root = File.join DATA_DIR_BASE, institution.code

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

    compose_runset(files, run_config)

  end

  private

  def compose_runset(files, run_config)

    return nil unless files

    run_set = RunSet.new

    files.each do |file_path|

      begin
        file_first_line = File.open(file_path, &:readline)
      rescue StandardError => e
        @institution.logger.error("File read error: #{e.message}")
        next
      end

      case detect_type_of_file(file_first_line)

        when 'exp_date'

          run_set.exp = File.new file_path

        when 'barcode'

          run_set.barcode = File.new file_path

        when 'patron_sif'

          run_set.data = File.new file_path
          run_config[:file_type] = :sif

        when 'patron_txt'

          run_set.data = File.new file_path
          run_config[:file_type] = :txt

        when 'unknown'

          @institution.logger.warn("Mystery file encountered: #{file_path}")

        else

          @institution.logger.error("File handling error for file: #{file_path}")

      end

    end
      
    run_set.config = run_config
    run_set.inst = @institution

    run_set

  end

  def get_files_in(path)
    Dir.glob path
  end

  def detect_type_of_file(line)

    if CSV.parse_line(line, col_sep: '|').length == TXT_FILE_FIELD_COUNT
      return 'patron_txt'
    end

    case line

      when /2[0-9]{3}[-][0-9]{2}[-][0-9]{2}$/ then 'exp_date'
      when /[0-9]{9}[|][0-9]+/ then 'barcode'
      when /.{400,}/ then 'patron_sif' # todo student/faculty?
      else 'unknown'

    end

  end

end