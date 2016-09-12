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

LOG_FILE = './log.log'
SECRETS_FILE = './config/secrets.yml'
DEFAULTS_FILE = './config/defaults.yml'
XML_TEMPLATE_FILE = './lib/templates/user_xml_v2_template.xml.erb'
SUPPORTED_FILE_TYPES = %w(txt sif)

log = Logger.new LOG_FILE

# Load configs
unless File.exist? SECRETS_FILE
  log.fatal "Secrets file could not be found @ #{SECRETS_FILE}. Stopping."
  exit
end

secrets = YAML.load_file SECRETS_FILE
unless secrets.is_a? Hash
  log.fatal 'Secrets config file not properly parsed. Stopping.'
  exit
  end

unless File.exist? DEFAULTS_FILE
  log.fatal "Defaults file could not be found @ #{DEFAULTS_FILE}. Stopping."
  exit
end

defaults = YAML.load_file DEFAULTS_FILE
unless defaults.is_a? Hash
  log.fatal 'Defaults config file not properly parsed. Stopping.'
  exit
end

unless ARGV.length == 2
  puts 'Input and Output files not defined, using testing defaults'
  ARGV[0] = './data/sample/sample.sif'
  # ARGV[0] = './data/sample/sample.txt'
  ARGV[1] = './data/sample/output.xml'
  # exit
end

input_file = ARGV[0]
output_file = ARGV[1]

if File.exist? output_file
  log.fatal 'Output file already exists. Stopping.'
  exit
end

unless File.exist? input_file
  log.fatal 'Input file not found. Stopping.'
  exit
end

file_type = input_file[-3..-1].downcase
unless SUPPORTED_FILE_TYPES.include? file_type
  log.fatal "Unacceptable file type found: #{file_type}. Supported types are: #{SUPPORTED_FILE_TYPES.join(', ')}"
  exit
end

# Load ERB Template
unless File.exist? XML_TEMPLATE_FILE
  log.fatal "Could not find XML template file @ #{XML_TEMPLATE_FILE}. Stopping."
  exit
end
template_file = File.open XML_TEMPLATE_FILE

# Convert defaults to OpenStruct for usage in XML template
defaults = OpenStruct.new defaults['global']

# start User processing
users = []
users_count = 0
row_count = 0
errors = 0

# Handle SIF file
if file_type == 'sif'
  File.open(input_file, 'r') do |f|
    f.each_line do |line|
      row_count += 1
      begin
        users << SifUser.new(line)
        users_count += 1
      rescue Exception => e
        log.error "Couldn't create User object from SIF row #{row_count}: #{e.message}"
        errors += 1
      end
    end
  end
# Handle TXT (CSV, piped) file
elsif file_type == 'txt'
  File.open(input_file, 'r') do |f|
    f.each_line do |line|
      row_count += 1
      begin
        users << TxtUser.new(line)
        users_count += 1
      rescue Exception => e
        log.error "Couldn't create User object from TXT row #{row_count}: #{e.message}"
        errors += 1
      end
    end
  end
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
  log.fatal "Problem with compressing XML file for delivery: #{e.message}"
  exit
end

# ftp file
remote_file = alma_file.gsub('./data/sample/','test/')
begin
  Net::SFTP.start(secrets['ftp']['url'], secrets['ftp']['user'], password: secrets['ftp']['pass'], port: secrets['ftp']['port']) do |c|
    c.upload! alma_file, remote_file
  end
rescue Exception => e
  log.fatal "Problem delivering file to GIL FTP server: #{e.message}"
  exit
end

log.info 'Output created: ' + output_file
log.info 'Payload delivered: ' + remote_file
log.info 'Users included: ' + users_count.to_s
log.info 'Users not included due to errors: ' + errors.to_s