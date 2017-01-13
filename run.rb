require 'logger'
require 'yaml'
require 'zip'
require './lib/classes/institution'
require './lib/classes/zipper'
require './lib/classes/xml_factory'
require './lib/classes/mailer'
require './lib/util'
include Util::App

LOG_FILE     = './log.log'
FILES_ROOT   = '/gilftpfiles'
DROP_POINT   = '/sis/synchronize'

start = Time.now

@script_logger = Logger.new LOG_FILE

# Load params
code = ARGV[0]
dry_run = ARGV.include? 'dry-run'
expire = ARGV.include? 'expire'

begin
  @institution = Institution.new(code)
rescue StandardError => e
  exit_log_error "Institution error: #{e.message}"
end

begin
  output_file = expire ? XmlFactory.expire_for(@institution) : XmlFactory.generate_for(@institution)
rescue StandardError => e
  exit_log_error "Script failed for #{code} with: #{e.message}"
end

# zip up file
zip_file = Zipper.do output_file, @institution

unless dry_run

  # MOVE FOR ALMA PICKUP
  source_file = File.join zip_file.path
  destination_file = File.join FILES_ROOT, @institution.code, DROP_POINT, File.basename(zip_file.path)
  FileUtils.mv(source_file, destination_file)

  message = "Uploaded patron file for #{@institution.code} processed and sent to Alma for processing."

  @institution.mailer.send_finished_notification

end

puts "File Generation complete for #{@institution.code}"
puts "Time: #{Time.now - start} seconds"