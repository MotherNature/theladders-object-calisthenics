$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'labels'
require 'jobs'

describe JobListReportGenerator do
  before(:each) do
    jobfactory = JobFactory.new

    @job1 = jobfactory.build_job(title_string: "Applied Technologist", jobtype_string: "ATS")
    @job2 = jobfactory.build_job(title_string: "Bench Warmer", jobtype_string: "ATS")
    @job3 = jobfactory.build_job(title_string: "Candy Tester", jobtype_string: "ATS")

    @joblistreportgenerator = JobListReportGenerator.new
  end

  describe "Generate Job Report" do
    it "should list Jobs, showing their Title and the Name of the Recruiter who posted it" do
      pending
      joblist = JobList.new([@job1, @job2, @job3])
      joblistreport = @joblistreportgenerator.generate_from(joblist)
      joblistreport.to_string.should ==
        "Job Title: Applied Technologist\nRecruiter: Alice Smith" +
        "Job Title: Bench Warmer\nRecruiter: Brenda Long" +
        "Job Title: Candy Tester\nRecruiter: Cindi Bond"
    end
  end
end
