require './lib/classes/users/sif_user'

class UngUser < SifUser

  def barcode
    @primary_id
  end

end