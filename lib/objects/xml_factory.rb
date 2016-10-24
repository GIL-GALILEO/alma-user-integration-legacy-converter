require './lib/objects/institution'
require './lib/objects/user_factory'
require './lib/objects/templater'

class XmlFactory

  def self.generate_for(code)

    # Prepare institution
    begin
      institution = Institution.new(code)
    rescue StandardError => e
      raise StandardError.new("XML Factory (Institution) error: #{e.message}")
    end

    # Generate Users
    begin
      users = UserFactory.generate(institution)
    rescue StandardError => e
      raise StandardError.new("XML Factory (UserFactory) error: #{e.message}")
    end

    # Generate XML
    begin
      o = Templater.run users, institution
    rescue StandardError => e
      raise StandardError.new("XML Factory (Templater) error: #{e.message}")
    end

    o

  end

end