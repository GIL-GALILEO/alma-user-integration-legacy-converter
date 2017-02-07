require 'fileutils'
require 'zip'

class Zipper

  ZIP_ARCHIVE_PATH = '/gilftpfiles/__INST_CODE__/archive/'

  def self.do(file, institution)

    if institution.parent_inst
      files_path = ZIP_ARCHIVE_PATH.gsub('__INST_CODE__', institution.parent_inst.code)
    else
      files_path = ZIP_ARCHIVE_PATH.gsub('__INST_CODE__', institution.code)
    end

    FileUtils::mkpath files_path

    file_basename = File.basename file
    xml_file_path = File.join files_path, file_basename
    zip_file_name = file_basename.gsub '.xml', '.zip'
    zip_file_path = File.join files_path, zip_file_name

    begin

      Zip::File.open(zip_file_path, Zip::File::CREATE) do |zipfile|
        zipfile.add file_basename, File.realpath(file)
      end

    rescue Exception => e

      raise StandardError.new("Problem compressing XML file for delivery: #{e.message}")

    end

    FileUtils.mv(File.realpath(file), xml_file_path)

    File.new zip_file_path

  end

end