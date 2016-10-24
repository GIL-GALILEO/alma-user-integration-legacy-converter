require 'csv'
require './lib/objects/txt_user'
require './lib/objects/sif_user'

class UserFactory

  DATA_DIR_BASE = './data/'
  TXT_FIELD_COUNT = 22

  def self.generate(institution)

    unless institution.kind_of? Institution
      raise StandardError.new('Bad Institution provided to user factory')
    end

    files_path = DATA_DIR_BASE + "#{institution.code}/*"
    files = Dir.glob(files_path)
    files_found = files.length
    patron_file = false
    user_class = nil
    barcode_data = nil
    exp_date_from_file = nil

    if files_found == 0
      institution.logger.warning 'No files found'
      return nil
    else
      institution.logger.info "#{files_found} files found for processing"
    end

    files.each do |file_path|

      begin
        file_first_line = File.open(file_path, &:readline)
      rescue StandardError => e
        institution.logger.error("File read error: #{e.message}")
        next
      end

      case detect_type_of_file(file_first_line)

        when 'exp_date'

          exp_date_from_file = file_first_line.strip

        when 'barcode'

          barcode_array = CSV.read(file_path, col_sep: '|')
          barcode_data = Hash[*barcode_array.flatten]

        when 'patron_sif'

          patron_file = file_path
          user_class = SifUser

        when 'patron_txt'

          patron_file = file_path
          user_class = TxtUser

        when 'unknown'

          institution.logger.warn("Mystery file encountered: #{file_path}")

        else

          institution.logger.error("File handling error for file: #{file_path}")

        end

    end

    users = []
    error_count = 0

    if patron_file and user_class

      File.foreach(patron_file).with_index do |line, line_num|

        begin
          users << user_class.new(line, institution)
        rescue StandardError => e
          error_count += 1
          institution.logger.error("Problem loading line #{line_num} from file: #{e.message}")
        end

      end

    else

      throw StandardError.new 'Problem processing patron file'

    end

    if error_count > 0
      institution.logger.warn "Errors encountered: #{error_count}"
    end

    # barcode and expiration date updating
    if institution.expect_barcodes? or institution.expect_exp_date?

      users.each do |u|

        if institution.expect_barcodes? and barcode_data[u.primary_id]
          u.barcode = barcode_data[u.primary_id]
        end

        if institution.expect_exp_date? and exp_date_from_file
          u.expiry_date = exp_date_from_file
          # todo default exp_date?
        end

      end

    end

    users

  end

  def self.detect_type_of_file(line)

    if CSV.parse_line(line, col_sep: '|').length == TXT_FIELD_COUNT
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