require 'csv'
require './lib/classes/institution'
require './lib/classes/run_set'

class FileHandler

  DATA_DIR_BASE = './data/'
  TXT_FILE_FIELD_COUNT = 22

  DROP_LOCATIONS = %w(full delta)

  def initialize(institution)

    unless institution.is_a? Institution
      raise StandardError.new('Cannot generate for something that is not an Institution!')
    end

    @inst_files_root = File.join DATA_DIR_BASE, institution.code

    @institution = institution

  end

  def generate

    run_config = {}
    run_set = nil

    # todo a run should only pick up files from a single location
    # todo this does the job, but doesn't seem ideal
    DROP_LOCATIONS.each do |loc|

      run_config[:run_type] = loc

      drop_location = File.join @inst_files_root, loc, '*'

      files = get_files_in drop_location

      unless files.length > 0
        break
      end

      run_set = compose_runset(files, run_config)

    end

    # return nil if no run_set was generated (no files found anywhere)
    run_set ? run_set : nil

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