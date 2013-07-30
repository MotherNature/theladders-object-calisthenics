class IDNumberService
  def initialize
    @id_index = 0
  end

  def generate_idnumber
    @id_index += 1
    IDNumber.new(@id_index.to_s)
  end
end
