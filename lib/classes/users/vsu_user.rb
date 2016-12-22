require './lib/classes/users/sif_user'

class WestGaUser < SifUser

  VSU_USER_SEGMENT_LENGTH = 488
  VSU_ADDRESS_SEGMENT_LENGTH = 429
  VSU_MAXIMUM_ADDRESS_SEGMENTS = 1

  VSU_GENERAL_MAPPING = {
      user_group: [45, 55],
      first_name: [340, 360],
      middle_name: [360, 380],
      last_name: [310, 330],
      email: [917, 967],
      barcode: [20, 29],
      primary_id: [238, 248],
  }

  VSU_ADDRESS_SEGMENT_MAPPING = {
      address_line_1:           [0, 99],
      address_line_2:           [99, 199],
      address_city:             [210, 250],
      address_state_province:   [250, 257],
      address_postal_code:      [257, 267],
      address_country:          [267, 287],
      address_phone:            [287, 307],
  }

  def general_mapping
    VSU_GENERAL_MAPPING
  end

  def user_segment_length
    VSU_USER_SEGMENT_LENGTH
  end

  def address_segment_length
    VSU_ADDRESS_SEGMENT_LENGTH
  end

  def maximum_address_segments
    VSU_MAXIMUM_ADDRESS_SEGMENTS
  end

  def address_segment_mapping
    VSU_ADDRESS_SEGMENT_MAPPING
  end

end