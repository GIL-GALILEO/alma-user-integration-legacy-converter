require 'slack'
require 'yaml'
# require './lib/classes/institution'
# require './lib/classes/user'

class Slacker

  SECRETS_FILE = './config/secrets.yml'
  CHANNEL = 'alma-patron-loads'

  def initialize(institution)

    @inst = institution

    secrets = YAML.load_file SECRETS_FILE

    Slack.configure do |config|
      config.token = secrets['slack_api_token']
    end

  end

  def post(text, options = {})

    options.merge!({
        text: text,
        channel: CHANNEL,
        as_user: true
                   })

    Slack.chat_postMessage(options) unless defined?(MiniTest)

  end

  def users_extracted(users, errors)
    post(
        "Patron file from `#{@inst.code}` parsed. #{users} patrons extracted with #{errors} errors."
    )
  end

  def critical_error(text)
    post(
        "Job Failed for `#{@inst.code}`. Error message:\n#{text}"
    )
  end

  def run_completed
    post(
        "Job Completed for `#{@inst.code}`."
    )
  end

end