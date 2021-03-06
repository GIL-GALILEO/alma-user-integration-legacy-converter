require 'fileutils'
require 'zip'

class Zipper
  ZIP_ARCHIVE_PATH = '/gilftpfiles/__INST_CODE__/archive/'.freeze
  def self.do(file, institution)
    files_path = ZIP_ARCHIVE_PATH.gsub('__INST_CODE__', institution.code)
    FileUtils.mkpath files_path
    file_basename = File.basename file
    zip_file_name = file_basename.gsub '.xml', '.zip'
    zip_file_path = File.join files_path, zip_file_name
    begin
      Zip::File.open(zip_file_path, Zip::File::CREATE) do |zipfile|
        zipfile.add file_basename, File.realpath(file)
      end
    rescue StandardError => e
      # TODO cleanup failed run
      raise StandardError, "Problem compressing XML file for delivery: #{e.message}"
    end
    File.new zip_file_path
  end
end