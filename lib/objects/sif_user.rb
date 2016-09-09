require_relative 'user'

class SifUser < User

  MAPPING = {
          primary_id:               [31, 41],
          first_name:               [73, 92],
          middle_name:              [93, 112],
          last_name:                [43, 72],
          gender:                   nil,
          user_group:               [0, 9],
          campus_code:              nil,
          status:                   nil,
          address_line_1:           [141, 190],
          address_line_2:           [191, 240],
          address_city:             [271, 310],
          address_state_province:   [311, 317],
          address_postal_code:      [318, 327],
          address_country:          [328, 347],
          email:                    [469, 518],
          phone:                    [348, 372],
  }

  def initialize(line_data)
    MAPPING.each do |attr, width|
      self.send("#{attr}=", width ? line_data[width[0]..width[1]].strip : 'DEFAULT VALUE')
    end
  end

end