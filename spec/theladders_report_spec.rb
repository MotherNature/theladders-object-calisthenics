$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib', 'reports'))

Dir[File.join(File.dirname(__FILE__), '..', 'lib', 'reports', '*.rb')].each do |report_lib|
  require report_lib
end

require 'jobs'
require 'jobseekers'

describe "Jobseekers should be able to see a listing of the jobs for which they have applied" do
  before(:each) do
    @jobseeker = Jobseeker.new
    @other_jobseeker = Jobseeker.new
  end

  describe JobseekerApplicationsReport do
    it "should list the jobs to which a given jobseeker has applied" do
      job1 = Job.new(title: "Valid Job 1")
      job2 = Job.new(title: "Valid Job 2")

      @jobseeker.apply_to(job: job1)
      @jobseeker.apply_to(job: job2)

      list = JobseekerList.new([@jobseeker, @other_jobseeker]) 

      reportgenerator = JobseekerApplicationsReportGenerator.new(@jobseeker)

      report = reportgenerator.generate_from(list)

      report.to_string.should == "Valid Job 1\nValid Job 2"
    end

    it "should only list the jobs to which a given jobseeker has applied" do
      valid_job = Job.new(title: "Valid Job")
      @jobseeker.apply_to(job: valid_job)

      invalid_job = Job.new(title: "Invalid Job")
      @other_jobseeker.apply_to(job: invalid_job)

      list = JobseekerList.new([@jobseeker, @other_jobseeker]) 

      reportgenerator = JobseekerApplicationsReportGenerator.new(@jobseeker)

      report = reportgenerator.generate_from(list)

      report.to_string.should == "Valid Job"
    end
  end
end

