module Util

  def exit_log_error(message)
    @logger.fatal message
    exit
  end

end