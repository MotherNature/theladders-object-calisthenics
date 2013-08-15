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

describe "Jobseekers should be able to see a listing of jobs they have saved for later viewing" do
  describe SavedJobListReport do
    it "should list the jobs saved by a jobseeker" do
      jobseekers = JobseekerList.new([@jobseeker])
      report = SavedJobListReport.new(jobseekers)
      report.render.should == "Job[Title: A Job][Employer: Erin Employ]"
    end
  end

  before(:each) do
    @jobseeker = saving_jobseeker
    @jobseeker.save_job(posted_job)
  end
end

describe "Employers should be able to see a listing of the jobs they have posted" do
  # TODO: Add tests that check for *expected* additions to the JobList (otherwise, the tests could pass with the class just returning a static string 
  describe EmployersPostedJobReportGenerator do
    it "should generate a report that lists the jobs posted by an employer" do
      generates_with_expected_string_output_given_list(@joblist)
    end

    it "should generate a report that lists posted jobs and not unposted ones" do
      unposted_job = unposted_job(title: "Unposted Job", type: JobType.ATS)

      expanded_joblist = @joblist.with(unposted_job)

      generates_with_expected_string_output_given_list(expanded_joblist)
    end

    it "should generate a report that lists only the jobs posted by the given employer and not other employers" do
      other_employer = posting_employer(name: "Anne Nother")
      others_job = posted_job(title: "Not My Job", poster: other_employer)

      expanded_joblist = @joblist.with(others_job)

      generates_with_expected_string_output_given_list(expanded_joblist)
    end
  end

  before(:each) do
    @employer = posting_employer

    @job = posted_job(title: "A Job", poster: @employer)
    @job2 = posted_job(title: "Another Job", poster: @employer)

    @joblist = JobList.new([@job, @job2])

    @reportgenerator = EmployersPostedJobReportGenerator.new(@employer)
  end

  def generates_with_expected_string_output_given_list(joblist)
    report = @reportgenerator.generate_from(joblist)

    report.render.should == "Job[Title: A Job][Employer: Erin Employ]\nJob[Title: Another Job][Employer: Erin Employ]"
  end
end

describe "TheLadders should be able to get a report of what jobseekers have applied to jobs on any given day" do
  describe JobseekerAndJobsReport do
    it "should list the given jobseeker and all of the jobs to which they have applied" do
      report = JobseekerAndJobsReport.new(@jobseeker)
      report.render.should == @default_report
    end

    before(:each) do
      @jobseeker = applying_jobseeker

      @job = posted_job

      @jobseeker.apply_to(job: @job)

      @default_report = "Jobseeker[Name: Jane Jobseek]\nJob[Title: A Job][Employer: Erin Employ]"
    end
    
    def default_report_and(additional_string=nil)
      @default_report + "\n---\n" + additional_string
    end
  end

  describe JobseekersAndJobsListReport do
    it "should list the given jobseekers and all of the jobs to which they have applied" do
      report = JobseekersAndJobsListReport.new(@jobseekerlist)
      report.render.should == @default_report
    end

    it "should list the given jobseeker and all of the jobs to which they have applied, including just-added jobseekers" do
      new_jobseeker = applying_jobseeker(name: "Anne Nother")
      new_jobseeker.apply_to(job: @job)

      expanded_list = @jobseekerlist.with(new_jobseeker)
      report = JobseekersAndJobsListReport.new(expanded_list)
      report.render.should == @default_report + "\n---\nJobseeker[Name: Anne Nother]\nJob[Title: A Job][Employer: Erin Employ]"
    end

    it "should list the given jobseeker and all of the jobs to which they have applied, including just-applied-to jobs" do
      new_job = posted_job(title: "Another Job")
      @jobseeker.apply_to(job: new_job)

      report = JobseekersAndJobsListReport.new(@jobseekerlist)
      report.render.should == @default_report + "\nJob[Title: Another Job][Employer: Erin Employ]"
    end

    before(:each) do
      @jobseeker = applying_jobseeker

      @job = posted_job

      @jobseeker.apply_to(job: @job)

      @jobseekerlist = JobseekerList.new([@jobseeker])

      @default_report = "Jobseeker[Name: Jane Jobseek]\nJob[Title: A Job][Employer: Erin Employ]"
    end
  end
end

