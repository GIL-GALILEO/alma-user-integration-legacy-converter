require 'yaml'
require './lib/classes/institution'
require './lib/classes/file_handler'

CONFIG_FILE  = './config/inst.yml'.freeze

# for each inst, check drop point and send a slack msg if a new file is present
inst_configs = YAML.load_file CONFIG_FILE

inst_configs.each do |institution|
  institution = Institution.new institution[0]
  begin
    run_set = FileHandler.new(institution).run_set
    run_set.file_sets.each do |file_set|
      if file_set.patrons.length > 0
        times = file_set.patrons.map { |f| File.new(f).mtime }.join("\n")
        message = if file_set.campus
                    "`#{institution.code}` `#{file_set.campus.path}` has an unprocessed file. mtimes: ```#{times}```"
                  else
                    "`#{institution.code}` has an unprocessed file. mtimes: ```#{times}```"
                  end
        # institution.slacker.post(message) unless defined?(MiniTest)
        puts message unless defined?(MiniTest)
      end
    end
  rescue StandardError => e
    error_message = "problem with `#{institution.code}`: ```#{e}```"
    # institution.slacker.post(error_message) unless defined?(MiniTest)
    puts error_message unless defined?(MiniTest)
  end
end
