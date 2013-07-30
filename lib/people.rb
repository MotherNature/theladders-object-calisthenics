class Person
  def initialize(name: nil, idnumber: nil)
    @name = name
    @idnumber = idnumber
  end

  def name_to_string
    @name.to_string
  end
end
