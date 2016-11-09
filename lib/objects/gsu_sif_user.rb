require_relative 'sif_user'

class GsuSifUser < SifUser

  # All these values are guesses at this time!
  GENERAL_MAPPING = {
      user_group: [45, 55],
      first_name: [340, 360],
      middle_name: [360, 380],
      last_name: [310, 330],
      email: [917, 983],
      barcode: [20, 28],
      primary_id: [238, 248],
      # expiry_date: []
  }

  PRIMARY_ADDRESS_MAPPING = {
      address_line_1:           [488, 588],
      address_line_2:           [588, 698],
      address_city:             [698, 738],
      address_state_province:   [738, 745],
      address_postal_code:      [745, 756],
      # address_country:          [],
      # address_phone:            [],
      # mobile_phone:             [],
  }

  def initialize(line_data, institution)

    @institution = institution
    @line_data = line_data

    GENERAL_MAPPING.each do |attr, width|

      set_value(attr, extract_from_line(width[0], width[1]))

    end

    PRIMARY_ADDRESS_MAPPING.each do |attr, width|

      set_value("primary_#{attr}", extract_from_line(width[0], width[1]))

    end

  end

end