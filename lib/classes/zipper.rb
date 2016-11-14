require 'fileutils'
require 'zip'

class Zipper

  ZIP_ARCHIVE_PATH = 'data/__INST_CODE__/archive/'

  def self.do(string, institution)

    time = Time.now.strftime('%Y%m%d_%H%M%S')

    files_path = ZIP_ARCHIVE_PATH.gsub('__INST_CODE__',institution.code)
    files_name = "alma_xml_#{time}"

    FileUtils::mkpath files_path

    xml_file_name = files_name + '.xml'
    zip_file_name = files_name + '.zip'
    xml_file_path = File.join files_path, xml_file_name
    zip_file_path = File.join files_path, zip_file_name

    begin

      File.open(xml_file_path, 'w') { |file|
        file.write string
      }

      Zip::File.open(zip_file_path, Zip::File::CREATE) do |zipfile|
        zipfile.add xml_file_name, xml_file_path
      end

    rescue Exception => e

      raise StandardError.new("Problem compressing XML file for delivery: #{e.message}")

    end

    File.new zip_file_path

  end

end