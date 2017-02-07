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
sample = ARGV.include? 'sample'

if expire && sample
  exit_log_error "You've attempted to sample from an expire run. That is not supported!"
end

begin
  @institution = Institution.new(code)
rescue StandardError => e
  exit_log_error "Institution error: #{e.message}"
end

begin
  output_file = expire ? XmlFactory.expire_for(@institution) : XmlFactory.generate_for(@institution, sample)
rescue StandardError => e
  exit_log_error "Script failed for #{code} with: #{e.message}"
end

if output_file

  # zip up file
  zip_file = Zipper.do output_file, @institution

  unless dry_run

    # MOVE FOR ALMA PICKUP
    source_file = File.join zip_file.path
    if @institution.parent_inst
      destination_file = File.join FILES_ROOT, @institution.parent_inst.code, DROP_POINT, File.basename(zip_file.path)
    else
      destination_file = File.join FILES_ROOT, @institution.code, DROP_POINT, File.basename(zip_file.path)
    end
    FileUtils.mv(source_file, destination_file)

    @institution.mailer.send_finished_notification

  end

  puts "File Generation complete for #{@institution.code}"
  puts "Time: #{Time.now - start} seconds"

else

  puts "No files for #{@institution.code}"

end

