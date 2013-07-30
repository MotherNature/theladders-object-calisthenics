$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'labels'
require 'jobs'
require 'savedjobrecords'
require 'idnumberservice'

describe JobListReportGenerator do
  before(:each) do
    jobfactory = JobFactory.new
    idnumberservice = IDNumberService.new

    @job1 = jobfactory.build_job(title_string: "Applied Technologist", jobtype_string: "ATS")
    @job2 = jobfactory.build_job(title_string: "Bench Warmer", jobtype_string: "ATS")
    @job3 = jobfactory.build_job(title_string: "Candy Tester", jobtype_string: "ATS")

    @recruiter1 = Recruiter.new(name: Name.new("Alice Smith"), idnumber: idnumberservice.generate_idnumber)
    @recruiter2 = Recruiter.new(name: Name.new("Brenda Long"), idnumber: idnumberservice.generate_idnumber)
    @recruiter3 = Recruiter.new(name: Name.new("Cindi Maxton"), idnumber: idnumberservice.generate_idnumber)

    @joblistreportgenerator = JobListReportGenerator.new
  end

  describe "Generate Job Report" do
    it "should list jobs by their title and type by default" do
      joblist = JobList.new([@job1, @job2, @job3])
      joblistreport = @joblistreportgenerator.generate_from(joblist)
      joblistreport.to_string.should == "Title: Applied Technologist\nType: ATS\n---\nTitle: Bench Warmer\nType: ATS\n---\nTitle: Candy Tester\nType: ATS"
    end
    it "should list jobs by their title if specified" do
      joblist = JobList.new([@job1, @job2, @job3])
      joblistreport = @joblistreportgenerator.generate_titles_from(joblist)
      joblistreport.to_string.should == "Title: Applied Technologist\nTitle: Bench Warmer\nTitle: Candy Tester"
    end
  end
end
