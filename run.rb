require 'logger'
require 'yaml'
require 'zip'
require 'net/sftp'
require './lib/objects/institution'
require './lib/objects/user_factory'
require './lib/objects/templater'
require './lib/util'
include Util

LOG_FILE     = './log.log'
SECRETS_FILE = './config/secrets.yml'

@script_logger = Logger.new LOG_FILE

# Check for required files
exit_log_error("Secrets file could not be found @ #{SECRETS_FILE}. Stopping.")                        unless File.exist? SECRETS_FILE

# Load configs
secrets = YAML.load_file SECRETS_FILE

# Check configs
exit_log_error('Secrets config file not properly parsed. Stopping.') unless secrets.is_a? Hash

# Lead params
unless ARGV.length == 1
  puts 'Institution not defined, using testing defaults'
  ARGV[0] = 'dalton'
end

# Prepare institution
begin
  institution = Institution.new(ARGV[0])
rescue StandardError => e
  exit_log_error(e.message)
end

# Generate Users
begin
  users = UserFactory.generate(institution)
rescue StandardError => e
  exit_log_error(e.message)
end

# Generate XML
begin
  templater = Templater.new users, institution
  output_string = templater.run
rescue StandardError => e
  exit_log_error(e.message)
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