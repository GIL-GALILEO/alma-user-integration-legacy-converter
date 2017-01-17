require './lib/classes/users/sif_user'

class GptcUser < SifUser

  USER_SEGMENT_LENGTH       = 113

  def user_segment_length
    USER_SEGMENT_LENGTH
  end

end