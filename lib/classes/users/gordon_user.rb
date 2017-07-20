require './lib/classes/users/sif_user'

# custom SIF processing for Gordon
class GordonUser < SifUser

  GORDON_USER_SEGMENT_LENGTH = 466
  GORDON_ADDRESS_SEGMENT_LENGTH = 429
  GORDON_MAXIMUM_ADDRESS_SEGMENTS = 2

  GORDON_GENERAL_MAPPING = {
    barcode:             [20, 40],
    original_user_group: [45, 55],
    primary_id:          [238, 248],
    last_name:           [310, 330],
    first_name:          [340, 360],
    middle_name:         [360, 380]
  }.freeze

  GORDON_ADDRESS_SEGMENT_MAPPING = {
    address_type:             [0, 1],
    address_line_1:           [22, 72],
    address_line_2:           [72, 112],
    address_city:             [232, 272],
    address_state_province:   [272, 279],
    address_postal_code:      [279, 289],
    address_country:          [289, 309],
    address_phone:            [309, 323]
  }.freeze

  def general_mapping
    GORDON_GENERAL_MAPPING
  end

  def user_segment_length
    GORDON_USER_SEGMENT_LENGTH
  end

  def address_segment_length
    GORDON_ADDRESS_SEGMENT_LENGTH
  end

  def maximum_address_segments
    GORDON_MAXIMUM_ADDRESS_SEGMENTS
  end

  def address_segment_mapping
    GORDON_ADDRESS_SEGMENT_MAPPING
  end

end