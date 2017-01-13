require 'date'

module Util

  module App

    def exit_log_error(message)
      if @institution
        @institution.mailer.send_admin_notification message
      end
      @script_logger.fatal message
      puts "#{message}. See logs."
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
        value.rstrip
      else
        ''
      end
    end

    def set_value(attribute, value)
      self.send("#{attribute}=", value)
    end

  end

end