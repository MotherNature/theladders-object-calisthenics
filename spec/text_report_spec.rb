
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib', 'reports'))

Dir[File.join(File.dirname(__FILE__), '..', 'lib', 'reports', '*.rb')].each do |report_lib|
  require report_lib
end

require 'labels'
require 'jobs'
require 'jobseekers'
require 'employers'
require 'resumes'
require 'submissions'

require 'helpers'

RSpec.configure do |klass|
  klass.include Helpers
end

describe "Jobs, when displayed, should be displayed with a title and the name of the employer who posted it" do
  describe TextJobReport do
    describe UnpostedJob do
      it "should list the job title" do
        @report.render.should == "Job[Title: A Job]"
      end

      before(:each) do
        reportable = unposted_job.as_reportable
        @report = TextJobReport.new(reportable)
      end
    end

    describe PostedJob do
      it "should list the job title and the name of the employer that posted it" do
        @report.render.should == "Job[Title: A Job][Employer: Erin Employ]"
      end

      before(:each) do
        reportable = posted_job.as_reportable
        @report = TextJobReport.new(reportable)
      end
    end
  end
end

describe "Jobseekers should be able to see a listing of the jobs for which they have applied" do
  describe TextJobseekerApplicationsReport do
    it "should list the jobs to which a given jobseeker has applied" do
      reportgenerator = TextJobseekerApplicationsReportGenerator.new(@jobseeker)

      report = reportgenerator.generate_from(@jobseekerlist)

      report.render.should == "Job[Title: Valid Job 1][Employer: Erin Employ]\nJob[Title: Valid Job 2][Employer: Erin Employ]"
    end

    it "should only list the jobs to which a given jobseeker has applied" do
      reportgenerator = TextJobseekerApplicationsReportGenerator.new(@jobseeker)

      report = reportgenerator.generate_from(@jobseekerlist)

      report.render.should == "Job[Title: Valid Job 1][Employer: Erin Employ]\nJob[Title: Valid Job 2][Employer: Erin Employ]"
    end
  end

  before(:each) do
    @jobseeker = applying_jobseeker
    @other_jobseeker = applying_jobseeker

    posted_job1 = posted_job(title: "Valid Job 1")
    posted_job2 = posted_job(title: "Valid Job 2")

    employer = posting_employer
    other_job = unposted_job(title: "Invalid Job", type: JobType.ATS)

    other_posted_job = employer.post_job(other_job)

    @jobseeker.apply_to(job: posted_job1, with_resume: NoResume)
    @jobseeker.apply_to(job: posted_job2, with_resume: NoResume)

    @other_jobseeker.apply_to(job: other_posted_job, with_resume: NoResume)

    @jobseekerlist = JobseekerList.new([@jobseeker, @other_jobseeker]) 
  end
end

describe "Jobseekers should be able to see a listing of jobs they have saved for later viewing" do
  describe TextJobseekersSavedJobsReport do
    it "should list the jobs saved by a jobseeker" do
      report = TextJobseekersSavedJobsReport.new(@reportable)
      report.render.should == "Job[Title: Posted Job][Employer: Erin Employ]"
    end
  end

  before(:each) do
    repo = JobRepo.new
    job = posted_job(title: "Posted Job")
    jobseeker = saving_jobseeker(save_to_repo: repo)
    jobseeker.save_job(job)
    @reportable = repo.contents_as_reportable
  end
end

