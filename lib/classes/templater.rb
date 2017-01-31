require 'logger'
require 'erb'
require 'yaml'
require 'ostruct'

class Templater

  XML_TEMPLATE_FILE = './lib/templates/user_xml_v2_template.xml.erb'
  DEFAULTS_FILE = './config/defaults.yml'

  def self.run(users, run_set)

    institution = run_set.inst

    raise StandardError.new("Could not find XML template file @ #{XML_TEMPLATE_FILE}. Stopping.") unless File.exist? XML_TEMPLATE_FILE
    raise StandardError.new("Defaults file could not be found @ #{DEFAULTS_FILE}. Stopping.") unless File.exist? DEFAULTS_FILE

    defaults = YAML.load_file DEFAULTS_FILE

    raise StandardError.new('Defaults config file not properly parsed. Stopping.') unless defaults.is_a? Hash

    template = File.open XML_TEMPLATE_FILE
    defaults = OpenStruct.new defaults['global']

    # Read template
    template = ERB.new(template.read)

    if run_set.config.has_key?(:run_type) && run_set.config[:run_type] == :expire
      output_filename = "./temp/#{institution.code}_expire_patrons_#{Time.now.strftime('%Y%m%d')}.xml"
    else
      output_filename = "./temp/#{institution.code}_patrons_#{Time.now.strftime('%Y%m%d')}.xml"

    end

    file = File.open(output_filename, 'w')

    # Initialize XML
    file.puts "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n<users>"

    # Write User XML to output file
    row = 1
    users.each do |user|
      begin
        xml = template.result(binding).gsub("\n  \n", "\n") # remove any single blank lines?
        file.puts xml
      rescue Exception => e
        msg = "Error creating XML for User on row #{row}: #{e.message}"
        institution.logger.error msg
        institution.logger.mailer.add_script_error_message msg
      ensure
        row += 1
      end
    end

    file.puts '</users>'
    file.close
    file

  end

end