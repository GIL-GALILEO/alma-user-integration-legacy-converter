require './lib/classes/users/sif_user'

class GaSouUser < SifUser

  GA_SOU_USER_SEGMENT_LENGTH = 130
  GA_SOU_ADDRESS_SEGMENT_LENGTH = 328
  GA_SOU_MAXIMUM_ADDRESS_SEGMENTS = 3

  GA_SOU_GENERAL_MAPPING = {
      user_group:   [0, 9],
      last_name:    [32, 62],
      first_name:   [62, 82],
      middle_name:  [82, 102],
      primary_id:   [102, 111],
      barcode:      [102, 120]
  }

  GA_SOU_ADDRESS_SEGMENT_MAPPING = {
      address_type:             [0, 1],
      address_line_1:           [21, 70],
      address_line_2:           [70, 120],
      address_city:             [151, 190],
      address_state_province:   [191, 197],
      address_postal_code:      [198, 208],
      address_country:          [208, 225],
      address_phone:            [228, 253],
      address_mobile_phone:     [253, 278],
  }

  def general_mapping
    GA_SOU_GENERAL_MAPPING
  end

  def user_segment_length
    GA_SOU_USER_SEGMENT_LENGTH
  end

  def address_segment_length
    GA_SOU_ADDRESS_SEGMENT_LENGTH
  end

  def address_segment_mapping
    GA_SOU_ADDRESS_SEGMENT_MAPPING
  end

  def maximum_address_segments
    GA_SOU_MAXIMUM_ADDRESS_SEGMENTS
  end

end