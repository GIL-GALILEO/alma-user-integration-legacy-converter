require_relative 'gsu_user'

class WestGaUser < GsuUser

  def initialize(line_data, institution)

    super(line_data, institution)

    secondary_address_mapping.each do |attr, width|

      set_value("secondary_#{attr}", extract_from_line(width[0], width[1]))

    end

  end

  def general_mapping
    {
        user_group: [45, 55],
        first_name: [340, 360],
        middle_name: [360, 380],
        last_name: [310, 330],
        email: [1347, 1396], # todo
        barcode: [20, 28],
        primary_id: [238, 248],
        # expiry_date: [] # so many dates to choose from...
    }
  end

  def secondary_address_mapping
    {
        # address_line_1:           [488, 588],
        # address_line_2:           [588, 698],
        # address_city:             [698, 738],
        # address_state_province:   [738, 745],
        # address_postal_code:      [745, 756],
        # address_country:          [],
        # address_phone:            [],
        # mobile_phone:             [],
    }
  end

end