
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
  describe TextUnpostedJobReport do
    it "should list the job title" do
      @report.render.should == "Job[Title: A Job]"
    end

    before(:each) do
      reportable = unposted_job.as_reportable
      @report = TextUnpostedJobReport.new(reportable)
    end
  end

  describe TextPostedJobReport do
    it "should list the job title and the name of the employer that posted it" do
      @report.render.should == "Job[Title: A Job][Employer: Erin Employ]"
    end

    before(:each) do
      reportable = posted_job.as_reportable
      @report = TextPostedJobReport.new(reportable)
    end
  end
end

describe "Jobseekers should be able to see a listing of jobs they have saved for later viewing" do
  describe TextSavedJobListReport do
    it "should list the jobs saved by a jobseeker" do
      jobseekers = JobseekerList.new([@jobseeker])
      report = TextSavedJobListReport.new(jobseekers)
      report.to_string.should == "Job[Title: A Job][Employer: Erin Employ]"
    end
  end

  before(:each) do
    @jobseeker = saving_jobseeker
    @jobseeker.save_job(posted_job)
  end
end
