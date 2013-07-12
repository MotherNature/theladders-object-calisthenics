$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'labels'
require 'jobseekers'

describe JobseekerListReportGenerator do
  before(:each) do
    @jobseeker1 = Jobseeker.new(name: Name.new("Alice Green"))
    @jobseeker2 = Jobseeker.new(name: Name.new("Betty Smith"))
    @jobseeker3 = Jobseeker.new(name: Name.new("Candice Yarn"))

    @jobseekerlistreportgenerator = JobseekerListReportGenerator.new
  end

  describe "Generate Jobseeker Report" do
    it "should list Jobseekers, ordered by name" do
      jobseekerlist = JobseekerList.new([@jobseeker1, @jobseeker2, @jobseeker3])
      jobseekerlistreport = @jobseekerlistreportgenerator.generate_from(jobseekerlist)
      jobseekerlistreport.to_string.should == "Alice Green\nBetty Smith\nCandice Yarn"
    end

    it "should list Jobseekers, ordered by name, even when added out of order" do
      jobseekerlist = JobseekerList.new([@jobseeker3, @jobseeker2, @jobseeker1])
      jobseekerlistreport = @jobseekerlistreportgenerator.generate_from(jobseekerlist)
      jobseekerlistreport.to_string.should == "Alice Green\nBetty Smith\nCandice Yarn"
    end
  end
end
