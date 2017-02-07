require 'csv'
require 'fileutils'
require './lib/classes/run_set'
require './lib/classes/institution'
require './lib/classes/user'

class UserFactory

  def self.generate(run_set)

    unless run_set.kind_of? RunSet
      raise StandardError.new('Bad RunSet provided to user factory')
    end

    user_class = load_and_initialize_user_class run_set.inst.user_class

    unless user_class.ancestors.include? User
      raise StandardError.new('User class not loaded properly in user factory')
    end

    users = []
    error_count = 0

    if run_set.is_sufficient?

      run_set.data.each do |f|

        File.foreach(f).with_index do |line, line_num|

          begin
            user = user_class.new(line, run_set.inst)
            users << user if user.user_group # only process user if they have a user group
          rescue StandardError => e
            error_count += 1
            msg = "Problem loading line #{line_num + 1} from file: #{e.message}"
            run_set.inst.logger.warn msg
            run_set.inst.mailer.add_file_error_message msg
          end

        end

        # archive original uploaded file unless testing or sampling
        archive_raw_file(f, run_set.inst) unless defined? MiniTest || run_set.config[:sample]

      end

    else

      throw StandardError.new 'RunSet is not sufficient'

    end

    if error_count > 0
      run_set.inst.logger.warn "Errors encountered: #{error_count}"
    end

    if users.length == 0
      message = "No users created from file. Something's likely gone wrong."
      exit_log_error message
      run_set.inst.mailer.send_admin_notification message
    end

    # randomly sample from array if sample flag is set
    users = users.sample(5) if run_set.config[:sample]

    if run_set.barcode_hash || run_set.config[:run_type] == :expire

      users.each do |u|

        # set barcode
        if run_set.barcode_hash

          barcode = run_set.barcode_hash[u.primary_id]

          if barcode
            u.barcode = barcode
          else
            run_set.inst.logger.warn("Barcode for user (#{u.primary_id}) not found in file #{File.basename(run_set.barcode)}.")
          end

        end

        # set expire date if expire run
        u.expiry_date = date_days_from_now(0) if run_set.config[:run_type] == :expire

      end

      archive_raw_file(run_set.barcode, run_set.inst) unless defined?(MiniTest) || run_set.config[:sample]

    end


    run_set.inst.mailer.add_result_message "Users extracted from file: #{users.length}"

    users

  end

  def self.load_and_initialize_user_class(user_class)

    require "./lib/classes/users/#{user_class}"
    Kernel.const_get user_class.split('_').collect(&:capitalize).join

  end

  private

  def self.archive_raw_file(f, inst)

    inst = inst.parent_inst if inst.parent_inst

    Dir.mkdir(inst.raw_archive_path) unless File.exists? inst.raw_archive_path
    FileUtils.mv(File.absolute_path(f), File.join(inst.raw_archive_path, "#{File.basename(f)}_#{Time.now.strftime('%Y%m%d')}.raw"))

  end

end