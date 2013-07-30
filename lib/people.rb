class Person
  def initialize(name: nil)
    @identity = PersonIdentity.new(name: name, idnumber: IDNumber.new("PLACEHOLDER"))
  end

  def name_to_string
    @identity.name_to_string
  end
end
