require 'date'

module Util

  module App

    def exit_log_error(message, institution = nil)
      if institution
        institution.mailer.send_admin_notification message
        institution.logger.fatal message
        institution.slacker.critical_error message
      end
      puts "#{message} See logs."
      exit
    end

    def date_days_from_now(days)

      d = Date.parse(Time.now.to_s)
      (d + days).strftime('%Y-%m-%d')

    end

  end

  module File

    def extract_from_line(start, finish)
      value = @line_data[start...finish]
      if value
        value.strip
      else
        ''
      end
    end

    def set_value(attribute, value)
      send("#{attribute}=", value)
    end

  end

end