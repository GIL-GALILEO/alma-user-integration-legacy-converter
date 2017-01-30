require './lib/classes/user_factory'
require './lib/classes/templater'
require './lib/classes/file_handler'

class XmlFactory

  def self.generate_for(institution, sample = false)

    begin
      @run_set = FileHandler.new(institution).generate
    rescue StandardError => e
      raise StandardError.new("XML Factory (FileHandler) error: #{e.message}")
    end

    get_result sample

  end

  def self.expire_for(institution)

    begin
      @run_set = FileHandler.new(institution).generate(expire: true)
    rescue StandardError => e
      raise StandardError.new("XML Factory (FileHandler - Expire) error: #{e.message}")
    end

    get_result

  end

  def self.get_result(sample = false)

    @run_set.config[:sample] = sample

    begin
      users = UserFactory.generate(@run_set)
    rescue StandardError => e
      raise StandardError.new("XML Factory (UserFactory) error: #{e.message}")
    end

    begin
      result = Templater.run users, @run_set
    rescue StandardError => e
      raise StandardError.new("XML Factory (Templater) error: #{e.message}")
    end

    result

  end

end