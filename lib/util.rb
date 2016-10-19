module Util

  def exit_log_error(message)
    @script_logger.fatal message
    exit
  end

end