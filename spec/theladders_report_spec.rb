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

RSpec.configure do |klass|
  klass.include Helpers
end

describe "Jobseekers should be able to see a listing of the jobs for which they have applied" do
  before(:each) do
    @jobseeker = applying_jobseeker
    @other_jobseeker = applying_jobseeker

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

describe "Employers should be able to see a listing of the jobs they have posted" do
  before(:each) do
    @employer = posting_employer

    @job = posted_job(title: "A Job", poster: @employer)
    @job2 = posted_job(title: "Another Job", poster: @employer)

    @joblist = JobList.new([@job, @job2])

    @reportgenerator = EmployersPostedJobReportGenerator.new(@employer)
  end

  def generates_with_expected_string_output_given_list(joblist)
    report = @reportgenerator.generate_from(joblist)

    report.to_string.should == "Job[Title: A Job][Employer: Erin Employ]\nJob[Title: Another Job][Employer: Erin Employ]"
  end

  # TODO: Add tests that check for *expected* additions to the JobList (otherwise, the tests could pass with the class just returning a static string 
  describe EmployersPostedJobReportGenerator do
    it "should generate a report that lists the jobs posted by an employer" do
      generates_with_expected_string_output_given_list(@joblist)
    end

    it "should generate a report that lists posted jobs and not unposted ones" do
      unposted_job = UnpostedJob.new(title: "Unposted Job", type: JobType.ATS)

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
end

describe "Employers should be able to see jobseekers who have applied to their jobs by both job and day" do
  describe EmployersApplyingJobseekersByJobReportGenerator do
    before(:each) do
      @employer = posting_employer
      jobseeker1 = applying_jobseeker(name: "Jane Jobseek")
      jobseeker2 = applying_jobseeker(name: "Sandy Seeker")

      @job = posted_job(poster: @employer)
      jobseeker1.apply_to(job: @job)
      jobseeker2.apply_to(job: @job)

      @jobseekerlist = JobseekerList.new([jobseeker1, jobseeker2])

      @reportgenerator = EmployersApplyingJobseekersByJobReportGenerator.new(@employer)

      @basic_expected_string = "Jobseeker[Name: Jane Jobseek]\nJob[Title: A Job][Employer: Erin Employ]\n---\nJobseeker[Name: Sandy Seeker]\nJob[Title: A Job][Employer: Erin Employ]"
    end
    
    def generates_with_expected_string_output_given_list(jobseekerlist, additional_string=nil)
      report = @reportgenerator.generate_from(jobseekerlist)

      report.to_string.should == @basic_expected_string + (additional_string ? "\n---\n" + additional_string : "")
    end

    it "should list jobseekers that have applied to jobs posted by the given employer, and list the jobs to which they applied" do
      generates_with_expected_string_output_given_list(@jobseekerlist)
    end

    it "should list jobseekers that have applied to jobs posted by the given employer, including just-added ones, and list the jobs to which they applied" do
      other_jobseeker = applying_jobseeker(name: "Nancy Nother")
      other_jobseeker.apply_to(job: @job)

      expanded_jobseekerlist = @jobseekerlist.with(other_jobseeker)
      generates_with_expected_string_output_given_list(expanded_jobseekerlist, "Jobseeker[Name: Nancy Nother]\nJob[Title: A Job][Employer: Erin Employ]")
    end

    it "should list only jobseekers that have applied to jobs posted by the given employer, and list the jobs to which they applied" do
      other_jobseeker = applying_jobseeker(name: "Olaf Other")
      other_job = posted_job

      applicable_jobseeker = applying_jobseeker(name: "Andy Applier")
      applicable_jobseeker.apply_to(job: @job)

      expanded_jobseekerlist = @jobseekerlist.with(applicable_jobseeker)
      expanded_jobseekerlist = expanded_jobseekerlist.with(other_jobseeker)

      generates_with_expected_string_output_given_list(expanded_jobseekerlist, "Jobseeker[Name: Andy Applier]\nJob[Title: A Job][Employer: Erin Employ]")
    end
  end

  describe "If possible, we would like to be able to combine the 2 and see jobseekers who have applied to a given job on a given day" do
  end
end
