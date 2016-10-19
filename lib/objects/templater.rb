require 'logger'
require 'erb'
require 'yaml'
require 'ostruct'

class Templater

  XML_TEMPLATE_FILE = './lib/templates/user_xml_v2_template.xml.erb'
  DEFAULTS_FILE = './config/defaults.yml'

  def initialize(users, institution)

    raise StandardError.new("Could not find XML template file @ #{XML_TEMPLATE_FILE}. Stopping.") unless File.exist? XML_TEMPLATE_FILE
    raise StandardError.new("Defaults file could not be found @ #{DEFAULTS_FILE}. Stopping.") unless File.exist? DEFAULTS_FILE

    defaults = YAML.load_file DEFAULTS_FILE

    raise StandardError.new('Defaults config file not properly parsed. Stopping.') unless defaults.is_a? Hash

    @template_file = File.open XML_TEMPLATE_FILE
    @defaults = OpenStruct.new defaults['global']

    @users = users
    @institution = institution

  end

  def run

    output = ''

    # Read template
    template = ERB.new(@template_file.read)

    # Initialize XML
    output += "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n<users>"

    # Write User XML to output file
    row = 0
    @users.each do |user|
      begin
        output += template.result(binding)
      rescue Exception => e
        @institution.logger.error "Error creating XML for User on row #{row}: #{e.message}" # todo will this play nice with the block in run?
      ensure
        row += 1
      end
    end

    # Finish XML
    output += '</users>'

  end

end