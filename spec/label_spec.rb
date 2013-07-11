$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

require 'labels'

describe IDNumber do
  it "should initialize with a String for the ID" do
    idnumber = IDNumber.new("ID0001")

    idnumber.should be
  end

  it "should convert to a String" do
    idnumber = IDNumber.new("ID0001")

    idnumber.to_s.should == "ID0001"
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
