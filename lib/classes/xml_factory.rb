require './lib/classes/user_factory'
require './lib/classes/templater'

class XmlFactory

  def self.get_result(run_set)

    begin
      users = UserFactory.generate(run_set)
    rescue StandardError => e
      raise StandardError.new("XML Factory (UserFactory) error: #{e.message}")
    end

    begin
      result = Templater.run users, run_set
    rescue StandardError => e
      raise StandardError.new("XML Factory (Templater) error: #{e.message}")
    end

    result

  end

end