require './lib/classes/users/sif_user'

class GsuUser < SifUser

  GSU_USER_SEGMENT_LENGTH = 488
  GSU_ADDRESS_SEGMENT_LENGTH = 429
  GSU_MAXIMUM_ADDRESS_SEGMENTS = 1
  GSU_EXPIRY_DATE_FORMAT = '%Y.%m.%d'.freeze
  GSU_GENERAL_MAPPING = {
    original_user_group: [45, 55],
    original_secondary_user_group: [101, 111],
    original_expiry_date: [198, 209],
    first_name: [340, 360],
    middle_name: [360, 380],
    last_name: [310, 330],
    email: [917, 983],
    barcode: [20, 27],
    primary_id: [238, 248]
  }.freeze

  GSU_ADDRESS_SEGMENT_MAPPING = {
    address_line_1:           [0, 99],
    address_line_2:           [99, 199],
    address_city:             [210, 250],
    address_state_province:   [250, 257],
    address_postal_code:      [257, 267],
    address_country:          [267, 287],
    address_phone:            [287, 307]
  }.freeze

  def general_mapping
    GSU_GENERAL_MAPPING
  end

  def user_segment_length
    GSU_USER_SEGMENT_LENGTH
  end

  def address_segment_length
    GSU_ADDRESS_SEGMENT_LENGTH
  end

  def address_segment_mapping
    GSU_ADDRESS_SEGMENT_MAPPING
  end

  def maximum_address_segments
    GSU_MAXIMUM_ADDRESS_SEGMENTS
  end

  # use expiration date provided in SIF when returning expiry date for Alma
  def exp_date_for_alma
    alma_date(DateTime.strptime(original_expiry_date, GSU_EXPIRY_DATE_FORMAT).strftime('%Y-%m-%d'))
  end

end