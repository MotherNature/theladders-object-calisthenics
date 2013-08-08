$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib', 'reports'))

Dir[File.join(File.dirname(__FILE__), '..', 'lib', 'reports', '*.rb')].each do |report_lib|
  require report_lib
end

require 'jobs'
require 'jobseekers'
require 'employers'
require 'resumes'
require 'submissions'

describe "Jobseekers should be able to see a listing of the jobs for which they have applied" do
  before(:each) do
    @jobseeker = Jobseeker.new
    @other_jobseeker = Jobseeker.new

    @employer = Employer.new(name: "Robert Recruit")

    unposted_job1 = UnpostedJob.new(title: "Valid Job 1", type: JobType.ATS)
    unposted_job2 = UnpostedJob.new(title: "Valid Job 2", type: JobType.ATS)

    @employer = JobPoster.assign_role_to(@employer)

    @posted_job1 = @employer.post_job(unposted_job1)
    @posted_job2 = @employer.post_job(unposted_job2)

    other_job = UnpostedJob.new(title: "Invalid Job", type: JobType.ATS)

    @other_posted_job = @employer.post_job(other_job)

    @jobseeker.apply_to(job: @posted_job1, with_resume: NoResume)
    @jobseeker.apply_to(job: @posted_job2, with_resume: NoResume)

    @other_jobseeker.apply_to(job: @other_posted_job, with_resume: NoResume)

    @jobseekerlist = JobseekerList.new([@jobseeker, @other_jobseeker]) 
  end

  describe JobseekerApplicationsReport do
    it "should list the jobs to which a given jobseeker has applied" do
      reportgenerator = JobseekerApplicationsReportGenerator.new(@jobseeker)

      report = reportgenerator.generate_from(@jobseekerlist)

      report.to_string.should == "Job[Title: Valid Job 1][Employer: Robert Recruit]\nJob[Title: Valid Job 2][Employer: Robert Recruit]"
    end

    it "should only list the jobs to which a given jobseeker has applied" do
      reportgenerator = JobseekerApplicationsReportGenerator.new(@jobseeker)

      report = reportgenerator.generate_from(@jobseekerlist)

      report.to_string.should == "Job[Title: Valid Job 1][Employer: Robert Recruit]\nJob[Title: Valid Job 2][Employer: Robert Recruit]"
    end
  end
end

describe "Jobs, when displayed, should be displayed with a title and the name of the employer who posted it" do
  describe JobReport do
    before(:each) do
      employer = Employer.new(name: "Robert Recruit")

      job = UnpostedJob.new(title: "Example Job", type: JobType.ATS)

      employer = JobPoster.assign_role_to(employer)

      posted_job = employer.post_job(job)

      @report = JobReport.new(posted_job)
    end

    it "should list the job title and the name of the employer that posted it" do
      @report.to_string.should == "Job[Title: Example Job][Employer: Robert Recruit]"
    end

    it "should list the job title and the name of the employer that posted it" do
      @report.to_string.should == "Job[Title: Example Job][Employer: Robert Recruit]"
    end
  end
end

describe "Jobseekers can apply to jobs posted by employers" do
  it "There are 2 different kinds of Jobs posted by employers: JReq and ATS." do
  end

  before(:each) do
    @jobseeker = Jobseeker.new
    @other_jobseeker = Jobseeker.new
    @employer = Employer.new(name: "Robert Recruit")

    unposted_ats_job = UnpostedJob.new(title: "Example ATS Job", type: JobType.ATS)
    unposted_jreq_job = UnpostedJob.new(title: "Example JReq Job", type: JobType.JReq)

    @employer = JobPoster.assign_role_to(@employer)

    @ats_job = @employer.post_job(unposted_ats_job)
    @jreq_job = @employer.post_job(unposted_jreq_job)

    @resume = @jobseeker.draft_resume
  end

  describe "ATS jobs do not require a resume to apply to them" do
    describe Jobseeker do
      it "should be able to apply to ATS jobs without a resume" do
        submission = @jobseeker.apply_to(job: @ats_job, with_resume: NoResume)

        submission.valid?.should be_true
      end

      it "should not be able to apply to ATS jobs with a resume (missing from original spec)" do
        submission = @jobseeker.apply_to(job: @ats_job, with_resume: @resume)

        submission.valid?.should be_false
      end
    end
  end

  describe "JReq jobs require a resume to apply to them" do
    describe Jobseeker do
      it "should be able to apply to JReq jobs with a resume" do
        submission = @jobseeker.apply_to(job: @jreq_job, with_resume: @resume)

        submission.valid?.should be_true
      end

      it "should not be able to apply to JReq jobs without a resume" do
        submission = @jobseeker.apply_to(job: @jreq_job, with_resume: NoResume)

        submission.valid?.should be_false
      end
    end
  end

  describe "Jobseekers should be able to apply to different jobs with different resumes" do
    before(:each) do
      unposted_jreq_job2 = UnpostedJob.new(title: "Example JReq Job 2", type: JobType.JReq)

      @jreq_job2 = @employer.post_job(unposted_jreq_job2)

      @resume2 = @jobseeker.draft_resume
    end

    describe Jobseeker do
      it "should be able to apply to different jobs with different resume" do
        submission1 = @jobseeker.apply_to(job: @jreq_job, with_resume: @resume)
        submission2 = @jobseeker.apply_to(job: @jreq_job2, with_resume: @resume2)

        submission1.valid?.should be_true
        submission2.valid?.should be_true
      end
    end
  end

  describe "Jobseekers can not apply to a job with someone else’s resume" do
    before(:each) do
      @others_resume = @other_jobseeker.draft_resume
    end

    describe Jobseeker do
      it "cannot apply to a job with another jobseeker's resume" do
        submission = @jobseeker.apply_to(job: @jreq_job, with_resume: @others_resume)

        submission.valid?.should be_false
      end
    end
  end
end

describe "Jobseekers should be able to see a listing of jobs they have saved for later viewing" do
  before(:each) do
    @jobseeker = Jobseeker.new
    @jobseeker = JobSaver.with_role_performed_by(@jobseeker)

    employer = Employer.new(name: "Erin Employ")
    employer = JobPoster.with_role_performed_by(employer)

    unposted_job = UnpostedJob.new(title: "A Job", type: JobType.ATS)

    @job = employer.post_job(unposted_job)

    @jobseeker.save_job(@job)
  end

  describe SavedJobListReport do
    it "should list the jobs saved by a jobseeker" do
      jobseekers = JobseekerList.new([@jobseeker])
      report = SavedJobListReport.new(jobseekers)
      report.to_string.should == "Job[Title: A Job][Employer: Erin Employ]"
    end
  end
end
