require 'csv'
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

      File.foreach(run_set.data).with_index do |line, line_num|

        begin
          users << user_class.new(line, run_set.inst)
        rescue StandardError => e
          error_count += 1
          run_set.inst.logger.warn("Problem loading line #{line_num} from file: #{e.message}")
        end

      end

    else

      throw StandardError.new 'RunSet is not sufficient'

    end

    if error_count > 0
      run_set.inst.logger.warn "Errors encountered: #{error_count}"
    end

    if run_set.barcode_hash || run_set.config[:run_type] == :expire

      users.each do |u|

        u.barcode = run_set.barcode_hash[u.primary_id] if run_set.barcode_hash
        u.expiry_date = date_days_from_now(0) if run_set.config[:run_type] == :expire

      end

    end

    users

  end

  def self.load_and_initialize_user_class(user_class)

    require "./lib/classes/users/#{user_class}"
    Kernel.const_get user_class.split('_').collect(&:capitalize).join

  end

end