require 'logger'
require 'yaml'
require 'zip'
require 'net/sftp'
require './lib/classes/institution'
require './lib/classes/zipper'
require './lib/classes/xml_factory'
require './lib/util'
include Util::App

LOG_FILE     = './log.log'
SECRETS_FILE = './config/secrets.yml'

@script_logger = Logger.new LOG_FILE

# Check for required files
exit_log_error("Secrets file could not be found @ #{SECRETS_FILE}. Stopping.") unless File.exist? SECRETS_FILE

# Load configs
secrets = YAML.load_file SECRETS_FILE

# Check configs
exit_log_error('Secrets config file not properly parsed. Stopping.') unless secrets.is_a? Hash

# Load params
code = ARGV[0]
dry_run = ARGV[1] == 'dry-run'

begin
  institution = Institution.new(code)
rescue StandardError => e
  raise StandardError.new("Institution error: #{e.message}")
end

begin
  output_string = XmlFactory.generate_for institution
rescue StandardError => e
  exit_log_error "Script failed for #{code} with: #{e.message}"
end

# zip up file
zip_file = Zipper.do output_string, institution

unless dry_run

  remote_file = File.join(
      secrets['ftp']['path'].gsub('__inst__', institution.code),
      File.basename(zip_file)
  )

  begin
    Net::SFTP.start(
        secrets['ftp']['url'],
        secrets['ftp']['user'],
        password: secrets['ftp']['pass'],
        port: secrets['ftp']['port']) do |c|
      c.upload! zip_file, remote_file
    end
    @script_logger.info "File successfully delivered for #{institution.code}: #{zip_file}"
  rescue Exception => e
    exit_log_error "Problem delivering file to GIL FTP server: #{e.message}"
  end

  # todo send email notifications here

end

# done