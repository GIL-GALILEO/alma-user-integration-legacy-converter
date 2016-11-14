require './lib/classes/user_factory'
require './lib/classes/templater'

class XmlFactory

  def self.generate_for(institution)

    begin
      users = UserFactory.generate(institution)
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