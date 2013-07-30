$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'idnumberservice'

describe IDNumberService do
  it "can generate unique IDs" do
    service = IDNumberService.new
    idnumbers = []
    (1..10).each do
      idnumbers.push(service.generate_idnumber)
    end
    idnumbers.uniq.should == idnumbers
  end
end
