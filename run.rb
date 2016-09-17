require 'logger'
require 'csv'
require 'yaml'
require 'ostruct'
require 'erb'
require 'zip'
require 'net/sftp'
require './lib/objects/user'
require './lib/objects/sif_user'
require './lib/objects/txt_user'
require './lib/util'
include Util

LOG_FILE                  = './log.log'
SECRETS_FILE              = './config/secrets.yml'
DEFAULTS_FILE             = './config/defaults.yml'
INSTITUTION_CONFIG_FILE   = './config/inst.yml'
XML_TEMPLATE_FILE         = './lib/templates/user_xml_v2_template.xml.erb'
SUPPORTED_FILE_TYPES      = %w(txt sif)

@logger = Logger.new LOG_FILE

# Check for required files
exit_log_error("Secrets file could not be found @ #{SECRETS_FILE}. Stopping.")                        unless File.exist? SECRETS_FILE
exit_log_error("Institution config file could not be found @ #{INSTITUTION_CONFIG_FILE}. Stopping.")  unless File.exist? INSTITUTION_CONFIG_FILE
exit_log_error("Defaults file could not be found @ #{DEFAULTS_FILE}. Stopping.")                      unless File.exist? DEFAULTS_FILE
exit_log_error("Could not find XML template file @ #{XML_TEMPLATE_FILE}. Stopping.")                  unless File.exist? XML_TEMPLATE_FILE

# Load configs
secrets       = YAML.load_file SECRETS_FILE
inst_configs  = YAML.load_file INSTITUTION_CONFIG_FILE
defaults      = YAML.load_file DEFAULTS_FILE

# Check configs
exit_log_error('Secrets config file not properly parsed. Stopping.')      unless secrets.is_a? Hash
exit_log_error('Institution config file not properly parsed. Stopping.')  unless inst_configs.is_a? Hash
exit_log_error('Defaults config file not properly parsed. Stopping.')     unless defaults.is_a? Hash

# Lead params
unless ARGV.length == 3
  puts 'Input and Output files not defined, using testing defaults'
  # ARGV[0] = './data/sample/sample.sif'
  ARGV[0] = './data/sample/sample.txt'
  ARGV[1] = './data/sample/output.xml'
  # exit

  # institution shortname (temp?)
  ARGV[2] =  'uga'
end

input_file  = ARGV[0]
output_file = ARGV[1]

# Load ERB Template
template_file = File.open XML_TEMPLATE_FILE

exit_log_error('Output file already exists. Stopping.')   if File.exist? output_file
exit_log_error('Input file not found. Stopping.')         unless File.exist? input_file

file_type = input_file[-3..-1].downcase
exit_log_error("Unacceptable file type found: #{file_type}. Supported types are: #{SUPPORTED_FILE_TYPES.join(', ')}") unless SUPPORTED_FILE_TYPES.include? file_type

# Convert defaults to OpenStruct for usage in XML template
defaults = OpenStruct.new defaults['global']

# start User processing
users         = []
users_count   = 0
row_count     = 0
errors        = 0

# get specific institution config
exit_log_error("No config for specified inst: #{ARGV[2]}. Stopping.") unless inst_configs.has_key? ARGV[2]
inst_config = inst_configs[ARGV[2]]

# file type check
exit_log_error("File type specified in config (#{inst_config[:file_type]}) does not match provided file suffix (#{file_type}). Stopping") unless inst_config[:file_type] == file_type

case file_type

  when 'sif'

    File.open(input_file, 'r') do |f|
      f.each_line do |line|
        row_count += 1
        begin
          users << SifUser.new(line, inst_config)
          users_count += 1
        rescue Exception => e
          log.error "Couldn't create User object from SIF row #{row_count}: #{e.message}"
          errors += 1
        end
      end
    end

  when 'txt'

    File.open(input_file, 'r') do |f|
      f.each_line do |line|
        row_count += 1
        begin
          users << TxtUser.new(line, inst_config)
          users_count += 1
        rescue Exception => e
          log.error "Couldn't create User object from TXT row #{row_count}: #{e.message}"
          errors += 1
        end
      end
    end

  else
    exit_log_error "No handler configured for file type #{file_type}"

end

# Read template
template = ERB.new(template_file.read)

# Create and Open output file
output = File.open(output_file , 'w+')

# Initialize XML
output.puts "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n<users>"

# Write User XML to output file
users.each do |user|
  begin
    output.puts(template.result(binding))
  rescue Exception => e
    log.error "Error creating XML for User #{user.primary_id}: #{e.message}" # todo reconsider use of primary id in logs when in production
  end
end

# Finish XML
output.puts '</users>'

# Write to file and close
output.flush
output.close

# zip file
alma_file = output_file.gsub('.xml','.zip')
begin
  Zip::File.open(alma_file, Zip::File::CREATE) do |zipfile|
    zipfile.add output_file.gsub('./data/sample/',''), output_file
  end
rescue Exception => e
  exit_log_error "Problem compressing XML file for delivery: #{e.message}"
end

# ftp file
remote_file = alma_file.gsub('./data/sample/','test/')
begin
  Net::SFTP.start(secrets['ftp']['url'], secrets['ftp']['user'], password: secrets['ftp']['pass'], port: secrets['ftp']['port']) do |c|
    c.upload! alma_file, remote_file
  end
rescue Exception => e
  exit_log_error "Problem delivering file to GIL FTP server: #{e.message}"
end

log.info 'Output created: ' + output_file
log.info 'Payload delivered: ' + remote_file
log.info 'Users included: ' + users_count.to_s
log.info 'Users not included due to errors: ' + errors.to_s