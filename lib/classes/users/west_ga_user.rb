require './lib/classes/users/sif_user'

class WestGaUser < SifUser

  WESTGA_USER_SEGMENT_LENGTH = 488
  WESTGA_ADDRESS_SEGMENT_LENGTH = 429
  WESTGA_MAXIMUM_ADDRESS_SEGMENTS = 2

  WESTGA_GENERAL_MAPPING = {
      user_group: [45, 55],
      first_name: [340, 360],
      middle_name: [360, 380],
      last_name: [310, 330],
      email: [1347, 1396],
      barcode: [20, 29],
      primary_id: [238, 248],
  }

  WESTGA_ADDRESS_SEGMENT_MAPPING = {
      address_line_1:           [0, 99],
      address_line_2:           [99, 199],
      address_city:             [210, 249],
      address_state_province:   [250, 257],
      address_postal_code:      [257, 267],
      address_country:          [267, 287],
      address_phone:            [287, 307],
  }

  def general_mapping
    WESTGA_GENERAL_MAPPING
  end

  def user_segment_length
    WESTGA_USER_SEGMENT_LENGTH
  end

  def address_segment_length
    WESTGA_ADDRESS_SEGMENT_LENGTH
  end

  def maximum_address_segments
    WESTGA_MAXIMUM_ADDRESS_SEGMENTS
  end

  def address_segment_mapping
    WESTGA_ADDRESS_SEGMENT_MAPPING
  end

end