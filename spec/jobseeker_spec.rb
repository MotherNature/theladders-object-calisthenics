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
    @jobapplicationrecordservice = JobApplicationRecordService.new

    @savedjobrecordlist = SavedJobRecordList.new

    @jobseeker = Jobseeker.new(name: Name.new("Jane Doe"))

    @ats_job = @jobfactory.build_job(title_string: "Example Title", jobtype_string: "ATS")
    @jreq_job = @jobfactory.build_job(title_string: "Example Title", jobtype_string: "JReq")
  end

  describe "Save Job" do
    it "should be able to save a List of Jobs" do
      @savedjobrecordlist.save_job_for_jobseeker(job: @ats_job, jobseeker: @jobseeker)
      @savedjobrecordlist.jobs_saved_by(@jobseeker).should include @ats_job
    end
  end

  describe "Apply to Job" do
    before(:each) do
      @jobapplicationlist = JobApplicationList.new
      @postinglist = PostingList.new

      @recruiter = Recruiter.new(name: Name.new("Rachel McExample"))
      @jobseeker = Jobseeker.new(name: Name.new("Jane Doe"))

      @jobapplication = JobApplication.new(jobseeker: @jobseeker)

      @postinglist.post_job(job: @ats_job, posted_by: @recruiter)
      @postinglist.post_job(job: @jreq_job, posted_by: @recruiter)
    end

    it "should be able to apply to an ATS Job without a resume" do
      @jobapplicationrecordservice.apply_jobapplication_to_job(jobapplication: @jobapplication, job: @ats_job)
      
      @jobapplicationrecordservice.jobapplications_submitted_for_job(@ats_job).should include @jobapplication
    end

    it "should not be able to apply to a JReq Job without a resume" do
      expect {
        @jobapplicationrecordservice.apply_jobapplication_to_job(jobapplication: @jobapplication, job: @jreq_job)
      }.to raise_error(IncompatibleJobApplicationError)
      
      @jobapplicationrecordservice.jobapplications_submitted_for_job(@jreq_job).should_not include @jobapplication
    end

    it "should be able to apply to a JReq Job with a resume" do
      resume = Resume.new(jobseeker: @jobseeker)
      jobapplication = JobApplication.new(jobseeker: @jobseeker, resume: resume) 

      @jobapplicationrecordservice.apply_jobapplication_to_job(jobapplication: jobapplication, job: @jreq_job)
      
      @jobapplicationrecordservice.jobapplications_submitted_for_job(@jreq_job).should include jobapplication
    end

    it "should be able to apply to different Jobs with different Resumes" do
      resume1 = Resume.new(jobseeker: @jobseeker)
      resume2 = Resume.new(jobseeker: @jobseeker)
      
      jobapplication1 = JobApplication.new(jobseeker: @jobseeker, resume: resume1)
      jobapplication2 = JobApplication.new(jobseeker: @jobseeker, resume: resume2)

      @jobapplicationrecordservice.apply_jobapplication_to_job(jobapplication: jobapplication1, job: @ats_job)
      @jobapplicationrecordservice.apply_jobapplication_to_job(jobapplication: jobapplication2, job: @jreq_job)
      
      @jobapplicationrecordservice.jobapplications_submitted_for_job(@jreq_job).should include jobapplication1
      @jobapplicationrecordservice.jobapplications_submitted_for_job(@jreq_job).should include jobapplication2

      jobapplication1.has_this_resume?(resume1).should be_true
      jobapplication1.has_this_resume?(resume2).should be_false

      jobapplication2.has_this_resume?(resume2).should be_true
      jobapplication2.has_this_resume?(resume1).should be_false
    end

    it "should not be able to apply to Jobs with another Jobseeker's Resume" do
      jobseeker2 = Jobseeker.new(name: Name.new("Jane Deus"))

      resume2 = Resume.new(jobseeker: jobseeker2)

      expect {
        jobapplication = JobApplication.new(jobseeker: @jobseeker, resume: resume2)
      }.to raise_error(InvalidJobApplicationError)
    end
  end
end
