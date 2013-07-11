$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'labels'
require 'jobs'
require 'jobseekers'
require 'recruiters'
require 'postings'

describe Jobseeker do
  before(:each) do
      
    @jobfactory = JobFactory.new
    @jobapplicationrecordservice = JobApplicationRecordService.new

    @savedjobrecordlist = SavedJobRecordList.new

    @jobseeker = Jobseeker.new(name: Name.new("Jane Doe"))
  end

  describe "Save Job" do
    it "should be able to save a List of Jobs" do
      job = @jobfactory.build_job(title_string: "Example Title", jobtype_string: "ATS")
      @savedjobrecordlist.save_job_for_jobseeker(job: job, jobseeker: @jobseeker)
      @savedjobrecordlist.jobs_saved_by(@jobseeker).should include job
    end
  end

  describe "Apply to Job" do
    before(:each) do
      @jobapplicationlist = JobApplicationList.new
      @postinglist = PostingList.new

      @recruiter = Recruiter.new(name: Name.new("Rachel McExample"))
      @jobseeker = Jobseeker.new(name: Name.new("Jane Doe"))

      @jobapplication = JobApplication.new(jobseeker: @jobseeker)
    end

    it "should be able to apply to an ATS Job without a resume" do
      job = @jobfactory.build_job(title_string: "Example Job", jobtype_string: "ATS")
      @postinglist.post_job(job: job, posted_by: @recruiter)

      @jobapplicationrecordservice.apply_jobapplication_to_job(jobapplication: @jobapplication, job: job)
      
      @jobapplicationrecordservice.jobapplications_submitted_for_job(job).should include @jobapplication
    end

    it "should not be able to apply to a JReq Job without a resume" do
      job = @jobfactory.build_job(title_string: "Example Job", jobtype_string: "JReq")
      @postinglist.post_job(job: job, posted_by: @recruiter)

      expect {
        @jobapplicationrecordservice.apply_jobapplication_to_job(jobapplication: @jobapplication, job: job)
      }.to raise_error(InvalidJobApplicationError)
      
      @jobapplicationrecordservice.jobapplications_submitted_for_job(job).should_not include @jobapplication
    end

    it "should be able to apply to a JReq Job with a resume" do
      job = @jobfactory.build_job(title_string: "Example Job", jobtype_string: "JReq")
      @postinglist.post_job(job: job, posted_by: @recruiter)

      resume = Resume.new(jobseeker: @jobseeker)
      jobapplication = JobApplication.new(jobseeker: @jobseeker, resume: resume) 

      @jobapplicationrecordservice.apply_jobapplication_to_job(jobapplication: jobapplication, job: job)
      
      @jobapplicationrecordservice.jobapplications_submitted_for_job(job).should include jobapplication
    end
  end
end
