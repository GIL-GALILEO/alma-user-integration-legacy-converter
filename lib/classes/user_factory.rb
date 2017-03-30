require 'csv'
require 'fileutils'
require './lib/classes/run_set'
require './lib/classes/institution'
require './lib/classes/user'
require './lib/classes/user_group'

class UserFactory

  def self.generate(run_set)

    unless run_set.is_a? RunSet
      fail StandardError, 'Bad RunSet provided to user factory'
    end

    users = []
    users_hash = {}
    error_count = 0

    # for each file set, build user objects and barcode hash tables
    run_set.file_sets.each do |file_set|

      user_class = load_and_initialize_user_class(
        file_set.campus ? file_set.campus.user_class : run_set.inst.user_class
      )

      unless user_class.ancestors.include? User
        fail StandardError, 'User class not loaded properly in user factory'
      end

      unless file_set.is_a? FileSet
        fail StandardError, 'Run Set contains an invalid File Set.'
      end

      file_set.barcodes.each do |barcode_file|

        barcode_separator = file_set.campus ? file_set.campus.barcode_separator : run_set.inst.barcode_separator

        file_set.barcodes_hash = parse_barcodes barcode_file, barcode_separator

        archive_raw_file(barcode_file, run_set.inst) unless defined?(MiniTest) || run_set.sample?

      end

      file_set.patrons.each do |patron_file|

        File.foreach(patron_file).with_index do |line, line_num|

          begin

            user = user_class.new(line, run_set.inst, file_set.campus)
            ug = user.user_group
            id = user.primary_id

            if ug && id && id_is_reasonable(id)

              if users_hash[id]

                run_set.inst.logger.info "Duplicate patron found with ID #{id} on line #{line_num} with group #{ug}."

                same_user = users_hash[id]

                if ug.is_heavier_than? same_user.user_group

                  users_hash[id] = user

                  run_set.inst.logger.info "User data from line #{line_num} with group #{ug} has outweighed a previously processed version."

                end

              else

                users_hash[id] = user

              end

              # attempt to set barcode if hash is present
              users_hash[id].barcode = file_set.barcodes_hash[id] if file_set.barcodes_hash.any?

              # set campus code
              user.campus_code = file_set.campus.code if file_set.campus

              # set expire date
              if run_set.expire?
                users_hash[id].exp_date_days = 0
              elsif file_set.exp_date
                users_hash[id].exp_date_override = file_set.exp_date
              elsif run_set.file_exp_date?
                users_hash[id].exp_date_override = run_set.config[:exp_date_from_file]
              end

            else

              # either no user group or no primary_id, either way leave out of final user array

            end

          rescue StandardError => e
            error_count += 1
            msg = "Problem loading line #{line_num + 1} from file: #{e.message}"
            run_set.inst.logger.warn msg
            run_set.inst.mailer.add_file_error_message msg
          end

        end

        # archive original uploaded file unless testing or sampling
        archive_raw_file(patron_file, run_set.inst) unless defined?(MiniTest) || run_set.sample?

      end

      users += users_hash.values

    end

    if error_count > 0
      run_set.inst.logger.warn "Errors encountered: #{error_count}"
    end

    if users.length == 0
      message = "No users created from file. Something's likely gone wrong."
      exit_log_error message, run_set.inst
      run_set.inst.mailer.send_admin_notification message
    end

    # randomly sample from array if sample flag is set
    users = users.sample(5) if run_set.sample?

    run_set.inst.mailer.add_result_message "Users extracted from file: #{users.length}"

    run_set.inst.slacker.users_extracted users.length, error_count

    users

  end

  def self.load_and_initialize_user_class(user_class)

    require "./lib/classes/users/#{user_class}"
    Kernel.const_get user_class.split('_').collect(&:capitalize).join

  end

  def self.archive_raw_file(f, inst)

    Dir.mkdir(inst.raw_archive_path) unless File.exist? inst.raw_archive_path
    FileUtils.mv(File.absolute_path(f), File.join(inst.raw_archive_path, "#{File.basename(f)}_#{Time.now.strftime('%Y%m%d')}.raw"))

  end

  def self.parse_barcodes(file, separator)
    barcode_array = CSV.read(file, col_sep: separator)
    Hash[*barcode_array.flatten]
  end

  def self.id_is_reasonable(id)
    !(id == '000000000' || id == '')
  end

end