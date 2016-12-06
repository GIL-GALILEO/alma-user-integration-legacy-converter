require 'pg'
require './lib/classes/institution'
require './lib/classes/user'

class Databaser

  def initialize(institution)

    @inst = inst_code institution
    @connection = PG.connect({dbname: 'alma_sis_integration'})
    @table = "#{@inst}_patrons"

    # prepare statements
    @connection.prepare 'usr_chk', "SELECT 1 FROM #{@table} WHERE instid = $1;"
    @connection.prepare 'add_usr', "INSERT INTO #{@table} (instid) VALUES($1);"
    @connection.prepare 'all_usr', "SELECT instid FROM #{@table};"

  end

  def truncate_table

    @connection.exec "TRUNCATE TABLE #{@table} RESTART IDENTITY;"

  end

  def add_user_to_archive(user)

    execute 'add_usr', [user_id(user)]

  end

  def is_user_in_archive(user)

    user_id = user_id user

    z = execute 'usr_chk', [user_id]

    !z.empty?

  end

  def all_users_from_previous_load

    execute 'all_usr'

  end

  def close_connection
    @connection.close
  end

  private

  def inst_code(i)
    if i.kind_of? Institution
      i.code
    else
      i
    end
  end

  def user_id(u)
    if u.kind_of? User
      u.primary_id
    else
      u
    end
  end

  def execute(name, values = [])

    begin
      rs = @connection.exec_prepared name, values
      data = rs.values
    rescue PG::Error => e
      #todo ?
      return false
    end

    rs.clear if rs

    data.flatten

  end

end