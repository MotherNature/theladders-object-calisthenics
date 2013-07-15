$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'labels'
require 'jobseekers'
require 'jobs'
require 'postings'
require 'reports'

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

describe JobsAppliedToReportGenerator do
  describe "Generate \"Jobs applied to\" Report" do
    before(:each) do
      @jobseeker = Jobseeker.new(name: Name.new("Alice Green"))

      jobfactory = JobFactory.new

      @job1 = jobfactory.build_job(title_string: "Applied Technologist", jobtype_string: "ATS")
      @job2 = jobfactory.build_job(title_string: "Bench Warmer", jobtype_string: "ATS")
      @job3 = jobfactory.build_job(title_string: "Candy Tester", jobtype_string: "ATS")
    end

    it "should list Jobs applied to by the Jobseeker" do
      pending
    end
  end
end
