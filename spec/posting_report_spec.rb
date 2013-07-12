$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'labels'
require 'postings'

describe PostingListReportGenerator do
  before(:each) do
    jobfactory = JobFactory.new

    @job1 = jobfactory.build_job(title_string: "Applied Technologist", jobtype_string: "ATS")
    @job2 = jobfactory.build_job(title_string: "Bench Warmer", jobtype_string: "ATS")
    @job3 = jobfactory.build_job(title_string: "Candy Tester", jobtype_string: "ATS")

    @postinglistreportgenerator = PostingListReportGenerator.new
  end

  describe "Generate Posting Report" do
    it "should list Postings, showing their Job's Title and the Name of the Recruiter who posted it" do
      postinglist = PostingList.new([@job1, @job2, @job3])
      postinglistreport = @postinglistreportgenerator.generate_from(postinglist)
      postinglistreport.to_string.should == "Job Title: Applied Technologist\nRecruiter: Alice Smith\n---\nJob Title: Bench Warmer\nRecruiter: Brenda Long\n---\nJob Title: Candy Tester\nRecruiter: Cindi Bond"
    end
  end
end
