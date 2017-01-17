require './lib/classes/users/sif_user'

class GptcUser < SifUser

  GPTC_USER_SEGMENT_LENGTH       = 113

  def user_segment_length
    GPTC_USER_SEGMENT_LENGTH
  end

end