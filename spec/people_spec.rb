$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

describe IDNumber do
  it "should initialize with a String for the ID" do
    idnumber = IDNumber.new("ID0001")

    idnumber.should be
  end
end
