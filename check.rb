require 'yaml'
require './lib/classes/institution'

CONFIG_FILE  = './config/inst.yml'.freeze

# for each inst, check drop point and send a slack msg if a new file is present
inst_configs = YAML.load_file CONFIG_FILE

inst_configs.each do |institution|
  institution = Institution.new institution[0]
  next unless institution.unprocessed_file?
  message = "`#{institution.code}` has an unprocessed file"
  institution.slacker.post(message) unless defined?(MiniTest)
  puts message unless defined?(MiniTest)
end
