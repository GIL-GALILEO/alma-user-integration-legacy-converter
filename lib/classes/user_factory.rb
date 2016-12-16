require 'csv'
require './lib/classes/databaser'
require './lib/classes/run_set'
require './lib/classes/institution'
require './lib/classes/user'

class UserFactory

  def self.generate(run_set)

    unless run_set.kind_of? RunSet
      raise StandardError.new('Bad RunSet provided to user factory')
    end

    @run_set = run_set

    user_class = load_and_initialize_user_class run_set.inst.user_class

    unless user_class.ancestors.include? User
      raise StandardError.new('User class not loaded properly in user factory')
    end

    users = []
    error_count = 0

    barcode_hash = run_set.barcode_hash
    exp_date_from_file = run_set.exp_date

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

      throw StandardError.new 'Problem processing patron file'

    end

    if error_count > 0
      run_set.inst.logger.warn "Errors encountered: #{error_count}"
    end

    new_users = []

    users.each do |u|

      u.barcode = barcode_hash[u.primary_id] if barcode_hash

      u.expiry_date= exp_date_from_file if exp_date_from_file

      # do patron_group conversion
      set_patron_group u, run_set.inst

      new_users << u.primary_id

    end

    if run_set.inst.autoexpire_missing_users?

      bye_user_ids = users_to_expire run_set.inst, new_users

      users.concat user_objects_for_expired_users(bye_user_ids, user_class)

    end

    users

  end

  def self.user_objects_for_expired_users(bye_user_ids = [], user_class)

    bye_user_ids.map do |id|
      u = user_class.new
      u.primary_id = id
      u.expiry_date = Date.new.strftime('%Y-%m-%d')
      u
    end

  end

  def self.users_to_expire(institution, new_users = [])

    db = Databaser.new institution

    old_users = db.user_ids_from_previous_load

    old_users - new_users

  end

  def self.set_patron_group(user, inst)

    groups_translation = inst.groups_data

    if groups_translation.has_key? user.user_group
      user.user_group = groups_translation[user.user_group]
    else
      inst.logger.warn "Undefined user_group found: #{user.user_group}"
    end

  end

  def self.load_and_initialize_user_class(user_class)

    require_relative user_class
    Kernel.const_get user_class.split('_').collect(&:capitalize).join

  end

end