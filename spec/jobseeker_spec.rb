$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'labels'
require 'jobs'
require 'jobseekers'
require 'recruiters'
require 'postings'
require 'resumes'

describe Jobseeker do
  before(:each) do
      
    @jobfactory = JobFactory.new
    @submissionservice = SubmissionService.new

    @savedjobrecordlist = SavedJobRecordList.new

    @jobseeker = Jobseeker.new(name: Name.new("Jane Doe"))

    @recruiter = Recruiter.new(name: Name.new("Rudy Smith"))

    @ats_job = @jobfactory.build_job(title_string: "Example Title", jobtype_string: "ATS")
    @jreq_job = @jobfactory.build_job(title_string: "Example Title", jobtype_string: "JReq")

    @ats_job_posting = Posting.new(job: @ats_job, posted_by: @recruiter)
    @jreq_job_posting = Posting.new(job: @jreq_job, posted_by: @recruiter)
  end

  describe "Save Job" do
    it "should be able to save a List of Jobs" do
      @savedjobrecordlist.save_job_for_jobseeker(job: @ats_job, jobseeker: @jobseeker)
      @savedjobrecordlist.jobs_saved_by(@jobseeker).should include @ats_job
    end
  end

  describe "Apply to Job" do
    it "should be able to apply to an ATS Job Posting without a resume" do
      jobapplication = Application.new(jobseeker: @jobseeker)

      @submissionservice.apply_jobapplication_to_posting(jobapplication: jobapplication, posting: @ats_job_posting)
      
      @submissionservice.jobapplications_submitted_for_posting(@ats_job_posting).should include jobapplication
    end

    it "should not be able to apply to a JReq Job Posting without a resume" do
      jobapplication = Application.new(jobseeker: @jobseeker)

      expect {
        @submissionservice.apply_jobapplication_to_posting(jobapplication: jobapplication, posting: @jreq_job_posting)
      }.to raise_error(IncompatibleApplicationError)

      @submissionservice.jobapplications_submitted_for_posting(@jreq_job_posting).should_not include jobapplication
    end

    it "should be able to apply to a JReq Job Posting with a resume" do
      resume = Resume.new(jobseeker: @jobseeker)
      jobapplication = Application.new(jobseeker: @jobseeker, resume: resume) 

      @submissionservice.apply_jobapplication_to_posting(jobapplication: jobapplication, posting: @jreq_job_posting)
      
      @submissionservice.jobapplications_submitted_for_posting(@jreq_job_posting).should include jobapplication
    end

    it "should be able to apply to different Jobs Posting with different Resumes" do
      resume1 = Resume.new(jobseeker: @jobseeker)
      resume2 = Resume.new(jobseeker: @jobseeker)
      
      jobapplication1 = Application.new(jobseeker: @jobseeker, resume: resume1)
      jobapplication2 = Application.new(jobseeker: @jobseeker, resume: resume2)

      @submissionservice.apply_jobapplication_to_posting(jobapplication: jobapplication1, posting: @ats_job_posting)
      @submissionservice.apply_jobapplication_to_posting(jobapplication: jobapplication2, posting: @jreq_job_posting)
      
      @submissionservice.jobapplications_submitted_for_posting(@jreq_job_posting).should include jobapplication1
      @submissionservice.jobapplications_submitted_for_posting(@jreq_job_posting).should include jobapplication2

      jobapplication1.has_this_resume?(resume1).should be_true
      jobapplication1.has_this_resume?(resume2).should be_false

      jobapplication2.has_this_resume?(resume2).should be_true
      jobapplication2.has_this_resume?(resume1).should be_false
    end

    it "should not be able to apply to Jobs with another Jobseeker's Resume" do
      jobseeker2 = Jobseeker.new(name: Name.new("Jane Deus"))

      resume2 = Resume.new(jobseeker: jobseeker2)

      expect {
        jobapplication = Application.new(jobseeker: @jobseeker, resume: resume2)
      }.to raise_error(InvalidApplicationError)
    end
  end
end
