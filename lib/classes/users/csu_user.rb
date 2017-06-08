require './lib/classes/users/sif_user'

class CsuUser < SifUser

  def barcode
    "201#{@primary_id}"
  end

end