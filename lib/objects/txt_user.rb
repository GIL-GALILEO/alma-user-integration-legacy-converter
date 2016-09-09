require_relative 'user'

class TxtUser < User

  attr_accessor :name

  MAPPING = {
      primary_id: 0,
      name: 1,
      gender: nil,
      user_group: 2,
      campus_code: nil,
      status: nil,
      address_line_1: 3,
      address_line_2: nil,
      address_city: 4,
      address_state_province: 5,
      address_postal_code: 6,
      address_country: nil,
      email: 14,
      phone: 7,
  }

  def initialize(line_data)
    parsed_line = CSV.parse_line(line_data, col_sep: '|')
    MAPPING.each do |attr, index|
      if index
        value = parsed_line[index]
        self.send("#{attr}=", value ? value.strip : '')
      else
        self.send("#{attr}=", 'DEFAULT_VALUE')
      end
    end
  end

  def name=(full_name)
    @name = full_name
    names = full_name.split(',')
    names.map!(&:strip)
    self.last_name = names[0]
    other_names = names[1].split(' ')
    self.first_name = other_names[0]
    self.middle_name = other_names[1]
  end

end