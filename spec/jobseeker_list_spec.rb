$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'labels'
require 'jobseekers'
require 'idnumberservice'

describe JobseekerList do
  before(:each) do
    idnumberservice = IDNumberService.new

    @jobseeker1 = Jobseeker.new(name: Name.new("Alice Green"), idnumber: idnumberservice.generate_idnumber)
    @jobseeker2 = Jobseeker.new(name: Name.new("Betty Smith"), idnumber: idnumberservice.generate_idnumber)
    @jobseeker3 = Jobseeker.new(name: Name.new("Candice Yarn"), idnumber: idnumberservice.generate_idnumber)
  end

  describe "List Jobseekers" do
    it "should list Jobseekers, ordered by name" do
      jobseekerlist = JobseekerList.new([@jobseeker1, @jobseeker2, @jobseeker3])
      jobseekerlist.to_array.should == [@jobseeker1, @jobseeker2, @jobseeker3]
    end

    it "should list Jobseekers, ordered by name, even when added out of order" do
      jobseekerlist = JobseekerList.new([@jobseeker3, @jobseeker2, @jobseeker1])
      jobseekerlist.to_array.should == [@jobseeker1, @jobseeker2, @jobseeker3]
    end
  end
end

