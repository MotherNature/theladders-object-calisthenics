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

  describe "Apply to Job" do
    before(:each) do
      @jobapplicationlist = JobApplicationList.new
      @jobapplicationrecordservice = JobApplicationRecordService.new

      @title = Title.new("Example Title")

      @recruiter = Recruiter.new(name: Name.new("Rachel McExample"))
      @jobseeker = Jobseeker.new(name: Name.new("Jane Doe"))
    end

    it "should be able to apply to an ATS Job without a resume" do
      jobtype = jobtypefactory.build_jobtype("ATS")
      job = Job.new(title: @title, jobtype: jobtype)
      @postinglist.post_job(job: job, posted_by: @recruiter)

      jobapplication = JobApplication.new(jobseeker: @jobseeker)
      @jobapplicationrecordservice.apply_jobapplication_to_job(jobapplication: jobapplication, job: job)
      
      @jobapplicationrecordservice.jobapplications_submitted_for_job(job).should include jobapplication
    end

    it "should not be able to apply to a JReq Job without a resume" do
      # TODO: Refactor most of this spec into a helper method
      jobtype = jobtypefactory.build_jobtype("JReq")
      job = Job.new(title: @title, jobtype: jobtype)
      @postinglist.post_job(job: job, posted_by: @recruiter)

      jobapplication = JobApplication.new(jobseeker: @jobseeker)
      expect {
        @jobapplicationrecordservice.apply_jobapplication_to_job(jobapplication: jobapplication, job: job)
      }.to raise_error(InvalidJobApplicationError)
      
      @jobapplicationrecordservice.jobapplications_submitted_for_job(job).should_not include jobapplication
    end
  end
end
