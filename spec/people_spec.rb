$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

require 'labels'

describe IDNumber do
  it "should initialize with a String for the ID" do
    idnumber = IDNumber.new("ID0001")

    idnumber.should be
  end
end

describe Identity do
  it "should initialize with a Name and an IDNumber" do
    name = Name.new("Jane Smith")
    idnumber = IDNumber.new("ID0001")

    identity = Identity.new(name: name, idnumber: idnumber)

    identity.should be
  end
end
