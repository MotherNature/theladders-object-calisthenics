$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

require 'labels'

describe Name do
  it "should match Names created from the same String" do
    name1 = Name.new("Jane Smith")
    name2 = Name.new("Jane Smith")

    name1.same_name?(name2).should be_true
  end
end

describe IDNumber do
  it "should initialize with a String for the ID" do
    idnumber = IDNumber.new("ID0001")

    idnumber.should be
  end

  it "should convert to a String" do
    idnumber = IDNumber.new("ID0001")

    idnumber.to_s.should == "ID0001"
  end

  it "should match IDNumbers created from the same String" do
    idnumber1 = IDNumber.new("ID0001")
    idnumber2 = IDNumber.new("ID0001")

    idnumber1.same_id?(idnumber2).should be_true
  end

  it "should not match IDNumbers created from different Strings" do
    idnumber1 = IDNumber.new("ID0001")
    idnumber2 = IDNumber.new("ID9999")

    idnumber1.same_id?(idnumber2).should be_false
  end
end
