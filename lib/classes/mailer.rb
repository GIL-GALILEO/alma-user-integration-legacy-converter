require 'net/smtp'

class Mailer

  FROM_ADDRESS = 'mak@uga.edu'

  DEFAULT_TO_ADDRESS = 'mak@uga.edu'

  def self.send(to_address = DEFAULT_TO_ADDRESS, subject, message)

    message = <<END
From: GIL Alma Integrations <#{FROM_ADDRESS}>
Subject: #{subject}

#{message}
END

    Net::SMTP.start('localhost', 25) do |smtp|
      smtp.send_message(
          message,
          FROM_ADDRESS,
          'mak@uga.edu'
      )
    end

  end

end