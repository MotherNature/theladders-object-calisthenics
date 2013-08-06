$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib', 'reports'))

Dir[File.join(File.dirname(__FILE__), '..', 'lib', 'reports', '*.rb')].each do |report_lib|
  require report_lib
end

require 'jobs'
require 'jobseekers'
require 'recruiters'
require 'resumes'
require 'submissions'

describe "Jobseekers should be able to see a listing of the jobs for which they have applied" do
  before(:each) do
    @jobseeker = Jobseeker.new
    @other_jobseeker = Jobseeker.new

    @recruiter = Recruiter.new(name: "Robert Recruit")

    @applied_to_job1 = @recruiter.post_job(title: "Valid Job 1")
    @applied_to_job2 = @recruiter.post_job(title: "Valid Job 2")

    @other_job = @recruiter.post_job(title: "Invalid Job")

    @jobseeker.apply_to(job: @applied_to_job1)
    @jobseeker.apply_to(job: @applied_to_job2)

    @other_jobseeker.apply_to(job: @other_job)

    @jobseekerlist = JobseekerList.new([@jobseeker, @other_jobseeker]) 
  end

  describe JobseekerApplicationsReport do
    it "should list the jobs to which a given jobseeker has applied" do
      reportgenerator = JobseekerApplicationsReportGenerator.new(@jobseeker)

      report = reportgenerator.generate_from(@jobseekerlist)

      report.to_string.should == "Job[Title: Valid Job 1][Recruiter: Robert Recruit]\nJob[Title: Valid Job 2][Recruiter: Robert Recruit]"
    end

    it "should only list the jobs to which a given jobseeker has applied" do
      reportgenerator = JobseekerApplicationsReportGenerator.new(@jobseeker)

      report = reportgenerator.generate_from(@jobseekerlist)

      report.to_string.should == "Job[Title: Valid Job 1][Recruiter: Robert Recruit]\nJob[Title: Valid Job 2][Recruiter: Robert Recruit]"
    end
  end
end

describe "Jobs, when displayed, should be displayed with a title and the name of the recruiter who posted it" do
  describe JobReport do
    before(:each) do
      recruiter = Recruiter.new(name: "Robert Recruit")

      job = recruiter.post_job(title: "Example Job")

      @report = JobReport.new(job)
    end

    it "should list the job title and the name of the recruiter that posted it" do
      @report.to_string.should == "Job[Title: Example Job][Recruiter: Robert Recruit]"
    end

    it "should list the job title and the name of the recruiter that posted it" do
      @report.to_string.should == "Job[Title: Example Job][Recruiter: Robert Recruit]"
    end
  end
end

describe "Jobseekers can apply to jobs posted by recruiters" do
  it "There are 2 different kinds of Jobs posted by recruiters: JReq and ATS." do
  end

  before(:each) do
    @jobseeker = Jobseeker.new
    @recruiter = Recruiter.new(name: "Robert Recruit")
  end

  describe "ATS jobs do not require a resume to apply to them" do
    it "jobseekers should be able to apply to ATS jobs without a resume" do
      job = @recruiter.post_job(title: "Example Job", type: JobType.ATS)

      submission = @jobseeker.apply_to(job: job, resume: NoResume)

      submission.valid?.should be_true
    end

    it "jobseekers should not be able to apply to ATS jobs with a resume (missing from original spec)" do
      job = @recruiter.post_job(title: "Example Job", type: JobType.ATS)

      resume = @jobseeker.draft_resume

      submission = @jobseeker.apply_to(job: job, resume: resume)

      submission.valid?.should be_false
    end
  end

  describe "JReq jobs require a resume to apply to them" do
    it "jobseekers should be able to apply to JReq jobs with a resume" do
      job = @recruiter.post_job(title: "Example Job", type: JobType.JReq)

      resume = @jobseeker.draft_resume

      submission = @jobseeker.apply_to(job: job, resume: resume)

      submission.valid?.should be_true
    end

    it "jobseekers should not be able to apply to JReq jobs without a resume" do
      job = @recruiter.post_job(title: "Example Job", type: JobType.JReq)

      submission = @jobseeker.apply_to(job: job, resume: NoResume)

      submission.valid?.should be_false
    end
  end
end
