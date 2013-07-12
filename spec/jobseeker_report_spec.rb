$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'labels'
require 'jobseekers'

describe JobseekerList do
  before(:each) do
    @jobseeker1 = Jobseeker.new(name: Name.new("Alice Green"))
    @jobseeker2 = Jobseeker.new(name: Name.new("Betty Smith"))
    @jobseeker3 = Jobseeker.new(name: Name.new("Candice Yarn"))
  end

  describe "List Jobseekers" do
    it "should list Jobseekers, ordered by name" do
      jobseekerlist = JobseekerList.new([@jobseeker1, @jobseeker2, @jobseeker3])
      jobseekerlist.jobseekers_as_array(sort_by: :name).should == [@jobseeker1, @jobseeker2, @jobseeker3]
    end

    it "should list Jobseekers, ordered by name, even when added out of order" do
      jobseekerlist = JobseekerList.new([@jobseeker3, @jobseeker2, @jobseeker1])
      jobseekerlist.jobseekers_as_array(sort_by: :name).should == [@jobseeker1, @jobseeker2, @jobseeker3]
    end
  end
end
