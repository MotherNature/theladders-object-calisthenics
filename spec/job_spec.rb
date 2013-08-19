$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'jobs'
require 'jobseekers'
require 'employers'
require 'resumes'
require 'applications'

require 'helpers'

RSpec.configure do |klass|
  klass.include Helpers
end

describe "Jobseekers can apply to jobs posted by employers" do
  it "There are 2 different kinds of Jobs posted by employers: JReq and ATS." do
  end

  before(:each) do
    @jobseeker = applying_jobseeker
    @other_jobseeker = applying_jobseeker

    @ats_job = posted_job(title: "Example ATS Job", type: JobType.ATS)
    @jreq_job = posted_job(title: "Example JReq Job", type: JobType.JReq)

    @resume = @jobseeker.draft_resume
  end

  describe "ATS jobs do not require a resume to apply to them" do
    describe Jobseeker do
      it "should be able to apply to ATS jobs without a resume" do
        application = @jobseeker.apply_to_job(job: @ats_job, with_resume: NoResume)

        application.valid?.should be_true
      end

      it "should not be able to apply to ATS jobs with a resume (missing from original spec)" do
        application = @jobseeker.apply_to_job(job: @ats_job, with_resume: @resume)

        application.valid?.should be_false
      end
    end
  end

  describe "JReq jobs require a resume to apply to them" do
    describe Jobseeker do
      it "should be able to apply to JReq jobs with a resume" do
        application = @jobseeker.apply_to_job(job: @jreq_job, with_resume: @resume)

        application.valid?.should be_true
      end

      it "should not be able to apply to JReq jobs without a resume" do
        application = @jobseeker.apply_to_job(job: @jreq_job, with_resume: NoResume)

        application.valid?.should be_false
      end
    end
  end

  describe "Jobseekers should be able to apply to different jobs with different resumes" do
    before(:each) do
      @jreq_job2 = posted_job(title: "Example JReq Job 2", type: JobType.JReq)

      @resume2 = @jobseeker.draft_resume
    end

    describe Jobseeker do
      it "should be able to apply to different jobs with different resume" do
        application1 = @jobseeker.apply_to_job(job: @jreq_job, with_resume: @resume)
        application2 = @jobseeker.apply_to_job(job: @jreq_job2, with_resume: @resume2)

        application1.valid?.should be_true
        application2.valid?.should be_true
      end
    end
  end

  describe "Jobseekers can not apply to a job with someone else’s resume" do
    before(:each) do
      @others_resume = @other_jobseeker.draft_resume
    end

    describe Jobseeker do
      it "cannot apply to a job with another jobseeker's resume" do
        expect do
          application = @jobseeker.apply_to_job(job: @jreq_job, with_resume: @others_resume)
        end.to raise_error(WrongJobseekersResumeSubmissionException)
      end
    end
  end

  describe JobApplierRole do
    it "can apply even if its role-taker has taken on additional roles" do
      expect do
        jobseeker = applying_jobseeker
        saving_jobseeker = JobSaverRole.new(roletaker: jobseeker, save_to_repo: JobRepo.new)
        job = posted_job

        saving_jobseeker.apply_to_job(job: job)
        saving_jobseeker.save_job(job)
      end.to_not raise_error
    end
  end
end
