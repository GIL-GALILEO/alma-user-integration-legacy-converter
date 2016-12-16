require './lib/classes/user_factory'
require './lib/classes/templater'
require './lib/classes/file_handler'

class XmlFactory

  def self.generate_for(institution)

    begin
      run_set = FileHandler.new(institution).generate
    rescue StandardError => e
      raise StandardError.new("XML Factory (FileHandler) error: #{e.message}")
    end

    begin
      users = UserFactory.generate(run_set)
    rescue StandardError => e
      raise StandardError.new("XML Factory (UserFactory) error: #{e.message}")
    end

    begin
      result = Templater.run users, institution
    rescue StandardError => e
      raise StandardError.new("XML Factory (Templater) error: #{e.message}")
    end

    result

  end

end