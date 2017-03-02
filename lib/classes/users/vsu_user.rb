require './lib/classes/users/sif_user'

class VsuUser < SifUser

  VSU_USER_SEGMENT_LENGTH = 488
  VSU_ADDRESS_SEGMENT_LENGTH = 429
  VSU_MAXIMUM_ADDRESS_SEGMENTS = 1

  VSU_EXPIRY_DATE_FORMAT = '%Y.%m.%d'

  VSU_GENERAL_MAPPING = {
      original_user_group: [45, 55],
      original_expiry_date: [188,198],
      first_name: [340, 360],
      middle_name: [360, 380],
      last_name: [310, 330],
      email: [917, 967],
      # barcode: [20, 29], # barcode and primary id cannot be identical in Alma
      primary_id: [238, 248],
  }

  VSU_ADDRESS_SEGMENT_MAPPING = {
      address_line_1:           [0, 50],
      address_line_2:           [50, 90],
      address_city:             [210, 250],
      address_state_province:   [250, 257],
      address_postal_code:      [257, 267],
      address_country:          [267, 287],
      address_phone:            [287, 307],
      # address_mobile_phone:     [],
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

  # use expiration date provided in SIF when returning expiry date for Alma
  def exp_date_for_alma
    alma_date(DateTime.strptime(original_expiry_date, VSU_EXPIRY_DATE_FORMAT).strftime('%Y-%m-%d'))
  end

end