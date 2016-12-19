require './lib/classes/users/sif_user'

class GsuUser < SifUser

  USER_SEGMENT_LENGTH = 488
  ADDRESS_SEGMENT_LENGTH = 429
  MAXIMUM_ADDRESS_SEGMENTS = 1

  GENERAL_MAPPING = {
      user_group: [45, 55],
      first_name: [340, 360],
      middle_name: [360, 380],
      last_name: [310, 330],
      email: [917, 983],
      barcode: [20, 28],
      primary_id: [238, 248],
  }

  ADDRESS_SEGMENT_MAPPING = {
      address_line_1:           [0, 99],
      address_line_2:           [99, 199],
      address_city:             [210, 250],
      address_state_province:   [250, 257],
      address_postal_code:      [257, 267],
      address_country:          [267, 287],
      address_phone:            [287, 307],
  }

  def general_mapping
    GENERAL_MAPPING
  end

  def user_segment_length
    USER_SEGMENT_LENGTH
  end

  def address_segment_length
    ADDRESS_SEGMENT_LENGTH
  end

  def address_segment_mapping
    ADDRESS_SEGMENT_MAPPING
  end

  def maximum_address_segments
    MAXIMUM_ADDRESS_SEGMENTS
  end

end