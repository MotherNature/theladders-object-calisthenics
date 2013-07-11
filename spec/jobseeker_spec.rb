$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

require 'labels'
require 'job'
require 'jobseeker'
require 'recruiter'
require 'posting'

jobtypefactory = JobTypeFactory.new

describe Jobseeker do
  before(:each) do
    @postinglist = PostingList.new
    @savedjobrecordlist = SavedJobRecordList.new

    title = Title.new("Example Title")
    jobtype = jobtypefactory.build_jobtype("ATS")
    @job = Job.new(title: title, jobtype: jobtype)
    
    recruiter = Recruiter.new(name: Name.new("Rachel McExample"))
    @postinglist.post_job(job: @job, posted_by: recruiter)

    @jobseeker = Jobseeker.new(name: Name.new("Jane Doe"))
  end

  describe "Save Job" do
    it "should be able to save a List of Jobs" do
      @savedjobrecordlist.save_job_for_jobseeker(job: @job, jobseeker: @jobseeker)
      @savedjobrecordlist.jobs_saved_by(@jobseeker).should include @job
    end
  end
end
