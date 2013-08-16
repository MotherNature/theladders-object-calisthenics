
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

describe "TheLadders should be able to get a report of what jobseekers have applied to jobs on any given day" do
  describe ApplicationsByDateFilter do
    it "should filter down to applications submitted on a given date" do
      pending
    end
  end

  describe TextApplicantsReport do
    it "should, for each application, list the applying jobseeker" do
      applications = @service.all_applications

      report = TextApplicantsReport.new(applications)

      report.render.should == "Jobseeker[Name: Jane Jobseek]"
    end

    it "should, for each application, list the applying jobseeker, including those of just-added applications" do
      other_jobseeker = applying_jobseeker(name: "Anne Nother", apply_to_service: @service)
      other_jobseeker.apply_to_job(job: @job)

      applications = @service.all_applications

      report = TextApplicantsReport.new(applications)

      report.render.should == "Jobseeker[Name: Jane Jobseek]\nJobseeker[Name: Anne Nother]"
    end

    before(:each) do
      @service = ApplicationService.new
      @job = posted_job
      @jobseeker = applying_jobseeker(apply_to_service: @service)
      @jobseeker.apply_to_job(job: @job)
    end
  end

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

describe "Employers should be able to see a listing of the jobs they have posted" do
  describe TextEmployersPostedJobReportGenerator do
    it "should generate a report that lists the jobs posted by an employer, including just-added ones" do
      new_job = posted_job(title: "New Job", poster: @employer)
      expanded_joblist = @joblist.with(new_job)

      report = @reportgenerator.generate_from(expanded_joblist)

      report.render.should == "Job[Title: A Job][Employer: Erin Employ]\nJob[Title: Another Job][Employer: Erin Employ]\nJob[Title: New Job][Employer: Erin Employ]"
    end

    it "should generate a report that lists posted jobs and not unposted ones" do
      posted_job = posted_job(title: "Posted Job", poster: @employer)
      unposted_job = unposted_job(title: "Unposted Job")

      expanded_joblist = @joblist.with(posted_job).with(unposted_job)

      report = @reportgenerator.generate_from(expanded_joblist)

      report.render.should == "Job[Title: A Job][Employer: Erin Employ]\nJob[Title: Another Job][Employer: Erin Employ]\nJob[Title: Posted Job][Employer: Erin Employ]"
    end

    it "should generate a report that lists only the jobs posted by the given employer and not other employers" do
      other_employer = posting_employer(name: "Anne Nother")
      others_job = posted_job(title: "Another's Job", poster: other_employer)

      expanded_joblist = @joblist.with(others_job)

      new_generator = TextEmployersPostedJobReportGenerator.new(other_employer)

      report = new_generator.generate_from(expanded_joblist)

      report.render.should == "Job[Title: Another's Job][Employer: Anne Nother]"
    end

    it "should report nothing for an empty list" do
      empty_joblist = JobList.new

      report = @reportgenerator.generate_from(empty_joblist)

      report.render.should == ""
    end
  end

  before(:each) do
    @employer = posting_employer

    @job = posted_job(title: "A Job", poster: @employer)
    @job2 = posted_job(title: "Another Job", poster: @employer)

    @joblist = JobList.new([@job, @job2])

    @reportgenerator = TextEmployersPostedJobReportGenerator.new(@employer)
  end
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
  describe TextApplicationsJobsReport do
    it "should list the jobs to which a given jobseeker has applied, including new ones" do
      new_job = posted_job(title: "Valid Job 3")
      @jobseeker.apply_to_job(job: new_job)

      applications = @applicationservice.applications_by(@jobseeker)

      report = TextApplicationsJobsReport.new(applications)

      report.render.should == "Job[Title: Valid Job 1][Employer: Erin Employ]\nJob[Title: Valid Job 2][Employer: Erin Employ]\nJob[Title: Valid Job 3][Employer: Erin Employ]"
    end

    it "should only list the jobs to which a given jobseeker has applied" do
      new_job = posted_job(title: "New Job")

      new_jobseeker = applying_jobseeker(apply_to_service: @applicationservice)
      new_jobseeker.apply_to_job(job: new_job)

      applications = @applicationservice.applications_by(new_jobseeker)

      report = TextApplicationsJobsReport.new(applications)

      report.render.should == "Job[Title: New Job][Employer: Erin Employ]"
    end
  end

  before(:each) do
    @applicationservice = ApplicationService.new

    @jobseeker = applying_jobseeker(apply_to_service: @applicationservice)
    @other_jobseeker = applying_jobseeker

    posted_job1 = posted_job(title: "Valid Job 1")
    posted_job2 = posted_job(title: "Valid Job 2")

    employer = posting_employer
    other_job = unposted_job(title: "Invalid Job", type: JobType.ATS)

    other_posted_job = employer.post_job(other_job)

    @jobseeker.apply_to_job(job: posted_job1, with_resume: NoResume)
    @jobseeker.apply_to_job(job: posted_job2, with_resume: NoResume)

    @other_jobseeker.apply_to_job(job: other_posted_job, with_resume: NoResume)

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

