$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'labels'
require 'postings'

describe PostingListReportGenerator do
  before(:each) do
    jobfactory = JobFactory.new
    idnumberservice = IDNumberService.new

    @job1 = jobfactory.build_job(title_string: "Applied Technologist", jobtype_string: "ATS")
    @job2 = jobfactory.build_job(title_string: "Bench Warmer", jobtype_string: "ATS")
    @job3 = jobfactory.build_job(title_string: "Candy Tester", jobtype_string: "ATS")

    @recruiter1 = Recruiter.new(name: Name.new("Alice Smith"), idnumber: idnumberservice.generate_idnumber)
    @recruiter2 = Recruiter.new(name: Name.new("Brenda Long"), idnumber: idnumberservice.generate_idnumber)
    @recruiter3 = Recruiter.new(name: Name.new("Cindi Maxton"), idnumber: idnumberservice.generate_idnumber)

    @posting1 = Posting.new(job: @job1, posted_by: @recruiter1)
    @posting2 = Posting.new(job: @job2, posted_by: @recruiter2)
    @posting3 = Posting.new(job: @job3, posted_by: @recruiter3)

    @postinglistreportgenerator = PostingListReportGenerator.new
  end

  describe "Generate Posting Report" do
    it "should list Postings, showing their Job's Title and the Name of the Recruiter who posted it" do
      postinglist = PostingList.new([@posting1, @posting2, @posting3])
      postinglistreport = @postinglistreportgenerator.generate_from(postinglist)
      postinglistreport.to_string.should == "Job Title: Applied Technologist\nRecruiter: Alice Smith\n---\nJob Title: Bench Warmer\nRecruiter: Brenda Long\n---\nJob Title: Candy Tester\nRecruiter: Cindi Maxton"
    end
  end
end
