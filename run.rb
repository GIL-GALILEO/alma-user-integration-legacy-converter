require 'logger'
require 'yaml'
require 'zip'
require 'net/sftp'
require './lib/objects/xml_factory'
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
unless ARGV.length == 1
  puts 'Institution not defined, using testing defaults'
  ARGV[0] = 'dalton'
end

code = ARGV[0]

begin
  output_string = XmlFactory.generate_for code
rescue StandardError => e
  exit_log_error "Script failed for #{code} with: #{e.message}"
end

puts output_string

# zip file
# alma_file = output_file.gsub('.xml','.zip')
# begin
#   Zip::File.open(alma_file, Zip::File::CREATE) do |zipfile|
#     zipfile.add output_file.gsub('./data/sample/',''), output_file
#   end
# rescue Exception => e
#   exit_log_error "Problem compressing XML file for delivery: #{e.message}"
# end
#
# # ftp file
# remote_file = alma_file.gsub('./data/sample/','test/')
# begin
#   Net::SFTP.start(secrets['ftp']['url'], secrets['ftp']['user'], password: secrets['ftp']['pass'], port: secrets['ftp']['port']) do |c|
#     c.upload! alma_file, remote_file
#   end
# rescue Exception => e
#   exit_log_error "Problem delivering file to GIL FTP server: #{e.message}"
# end

# @logger.info 'Output created: ' + output_file
# @logger.info 'Payload delivered: ' + remote_file
# @logger.info 'Users included: ' + users_count.to_s
# @logger.info 'Users not included due to errors: ' + errors.to_s