require './lib/objects/user'
require './lib/objects/sif_user'
require './lib/objects/txt_user'
require 'csv'
require 'yaml'
require 'ostruct'
require 'erb'

unless ARGV.length == 2
  puts 'Input and Output files not defined, using testing defaults'
  ARGV[0] = './data/sample/sample.sif'
  # ARGV[0] = './data/sample/sample.txt'
  ARGV[1] = './data/sample/output.xml'
  # exit
end

input_file = ARGV[0]
output_file = ARGV[1]

file_type = input_file[-3..-1].downcase

# Load ERB Template
template_file = File.open('./lib/templates/user_xml_v2_template.xml.erb')

users = []

if file_type == 'sif'

  File.open(input_file, 'r') do |f|
    f.each_line do |line|
      users << SifUser.new(line)
    end
  end

elsif file_type == 'txt'
  File.open(input_file, 'r') do |f|
    f.each_line do |line|
      users << TxtUser.new(line)
    end
  end
else

  puts 'Invalid file format'
  exit

end

# Read template
template = ERB.new(template_file.read)

# Create and Open output file
output = File.open(output_file , 'w+')

# Define default values for XML
# todo: load from config as they may be different per institution? or hopefully not
defaults = OpenStruct.new
defaults.preferred_address_type = 'HOME'
defaults.preferred_phone_type   = 'MOBILE'
defaults.preferred_email_type   = 'PERSONAL'

# Initialize XML
output.puts "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n<users>"

# Write User XML to output file
users.each do |user|
  output.puts(template.result(binding))
end

# Finish XML
output.puts '</users>'

# Write to file and close
output.flush
output.close

puts 'Output created: ' + output_file
puts 'Users included: ' + users.length.to_s