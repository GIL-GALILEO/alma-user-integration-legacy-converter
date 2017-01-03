require './lib/classes/users/sif_user'

class UngUser < SifUser

  UNG_MAXIMUM_ADDRESS_SEGMENTS = 2

  def maximum_address_segments
    UNG_MAXIMUM_ADDRESS_SEGMENTS
  end

end