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

FILES_ROOT   = '/gilftpfiles'
PICKUP_POINT = '/patrondrop'
DROP_POINT   = '/sis/synchronize'

@script_logger = Logger.new LOG_FILE

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

  # MOVE FOR ALMA PICKUP
  source_file = File.join Dir.pwd, zip_file.path
  destination_file = File.join FILES_ROOT, institution.code, DROP_POINT, File.basename(zip_file.path)
  FileUtils.mv(source_file, destination_file)

  # todo send email notifications here

end

# done