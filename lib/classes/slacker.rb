require 'slack'
require 'yaml'

#
# Class for handling connecting to and sending messages to Slack
# TODO: Fail silently if no Net or Slack down
#
class Slacker

  SECRETS_FILE = './config/secrets.yml'.freeze
  CHANNEL = 'alma-patron-loads'.freeze

  def initialize(institution)

    @inst = institution

    secrets = YAML.load_file SECRETS_FILE

    Slack.configure do |config|
      config.token = secrets['slack_api_token']
    end

  end

  def post(text, options = {})

    options[:text] = text
    options[:channel] = CHANNEL
    options[:as_user] = true

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