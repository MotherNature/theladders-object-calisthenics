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

require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

describe "Jobseekers should be able to see a listing of the jobs for which they have applied" do
  before(:each) do
    @jobseeker = Jobseeker.new
    @other_jobseeker = Jobseeker.new

    posted_job1 = posted_job(title: "Valid Job 1")
    posted_job2 = posted_job(title: "Valid Job 2")

    employer = posting_employer
    other_job = UnpostedJob.new(title: "Invalid Job", type: JobType.ATS)

    other_posted_job = employer.post_job(other_job)

    @jobseeker.apply_to(job: posted_job1, with_resume: NoResume)
    @jobseeker.apply_to(job: posted_job2, with_resume: NoResume)

    @other_jobseeker.apply_to(job: other_posted_job, with_resume: NoResume)

    @jobseekerlist = JobseekerList.new([@jobseeker, @other_jobseeker]) 
  end

  describe JobseekerApplicationsReport do
    it "should list the jobs to which a given jobseeker has applied" do
      reportgenerator = JobseekerApplicationsReportGenerator.new(@jobseeker)

      report = reportgenerator.generate_from(@jobseekerlist)

      report.to_string.should == "Job[Title: Valid Job 1][Employer: Erin Employ]\nJob[Title: Valid Job 2][Employer: Erin Employ]"
    end

    it "should only list the jobs to which a given jobseeker has applied" do
      reportgenerator = JobseekerApplicationsReportGenerator.new(@jobseeker)

      report = reportgenerator.generate_from(@jobseekerlist)

      report.to_string.should == "Job[Title: Valid Job 1][Employer: Erin Employ]\nJob[Title: Valid Job 2][Employer: Erin Employ]"
    end
  end
end

describe "Jobs, when displayed, should be displayed with a title and the name of the employer who posted it" do
  describe JobReport do
    before(:each) do
      @report = JobReport.new(posted_job)
    end

    it "should list the job title and the name of the employer that posted it" do
      @report.to_string.should == "Job[Title: A Job][Employer: Erin Employ]"
    end
  end
end

describe "Jobseekers should be able to see a listing of jobs they have saved for later viewing" do
  before(:each) do
    @jobseeker = saving_jobseeker
    @jobseeker.save_job(posted_job)
  end

  describe SavedJobListReport do
    it "should list the jobs saved by a jobseeker" do
      jobseekers = JobseekerList.new([@jobseeker])
      report = SavedJobListReport.new(jobseekers)
      report.to_string.should == "Job[Title: A Job][Employer: Erin Employ]"
    end
  end
end
