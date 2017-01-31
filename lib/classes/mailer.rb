require 'net/smtp'
require 'uri'

class Mailer

  FROM_ADDRESS = 'gil@usg.edu'
  ADMIN_ADDRESS = 'mak@uga.edu'
  SMTP_SERVER = 'localhost'
  DEFAULT_TO_ADDRESS = 'mak@uga.edu'

  def initialize(institution)
    @script_errors = []
    @file_errors = []
    @results = []
    @institution = institution
  end

  def add_result_message(msg)
    @results << msg
  end

  def add_script_error_message(msg)
    @script_errors << msg
  end

  def add_file_error_message(msg)
    @file_errors << msg
  end

  def results
    @results
  end

  def script_errors
    @script_errors
  end

  def file_errors
    @file_errors
  end

  def send_finished_notification

    message = <<END
From: GIL Alma Integrations <#{FROM_ADDRESS}>
Subject: Patron File Sent to Alma for #{@institution.code}

Your patron file was parsed and successfully sent to Alma.

Results Info:
#{@results.join("\n")}

File warnings/errors:
#{@file_errors.empty? ? 'None' : @file_errors.join("\n")}

Have a nice day!

END

    email @institution.notification_emails, message

  end

  def send_admin_notification(message)

    message = <<END
From: GIL Alma Integrations <#{FROM_ADDRESS}>
Subject: Patron file parse script error for #{@institution.code}

#{message}

Script errors:
#{@script_errors.empty? ? 'None' : @script_errors.join("\n")}

File errors:
#{@file_errors.empty? ? 'None' : @file_errors.join("\n")}

Do something! Quickly!

END

    email ADMIN_ADDRESS, message

  end

  private

  def email(to, message)

    if to.is_a? Array
      to.each do |address|
        email address, message
      end
    else
      if to.is_a?(String) && to =~ URI::MailTo::EMAIL_REGEXP
        begin
          Net::SMTP.start(SMTP_SERVER, 25) do |smtp|
            smtp.send_message(
                message,
                FROM_ADDRESS,
                to
            )
          end
        rescue StandardError => e
          @institution.logger.warn "Email could not be sent to #{to}. Exception: #{e}"
        end
      else
        @institution.logger.warn "Bad email address encountered for #{@institution.code}: #{to}"
      end
    end

  end

end