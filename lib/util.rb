module Util

  module App

    def exit_log_error(message)
      @script_logger.fatal message
      exit
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