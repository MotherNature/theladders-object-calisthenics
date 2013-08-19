
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
require 'applications'

require 'helpers'

RSpec.configure do |klass|
  klass.include Helpers
end

describe "TheLadders should be able to get a report of what jobseekers have applied to jobs on any given day" do
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

  describe "Integration" do
    it "generate a report of applicants on a specific date" do
      jobseeker1 = applying_jobseeker(name: "Anne Plier", apply_to_service: @service)
      jobseeker2 = applying_jobseeker(name: "Betsy Becker", apply_to_service: @service)
      jobseeker3 = applying_jobseeker(name: "Candice Courter", apply_to_service: @service)
      other_jobseeker = applying_jobseeker(name: "Ophelia Other", apply_to_service: @service)

      jobseeker1.apply_to_job(job: @job, on_date: @date)
      jobseeker2.apply_to_job(job: @job, on_date: @date)
      jobseeker3.apply_to_job(job: @job, on_date: @date)
      other_jobseeker.apply_to_job(job: @job, on_date: @other_date)

      filter = ApplicationsByDateFilter.new(@date)
      applications = @service.select_applications_filtered_by([filter])

      report = TextApplicantsReport.new(applications)
      
      report.render.should == "Jobseeker[Name: Anne Plier]\nJobseeker[Name: Betsy Becker]\nJobseeker[Name: Candice Courter]"
    end

    before(:each) do
      @service = ApplicationService.new
      @job = posted_job

      @date = ApplicationDate.new(2013, 12, 13)
      @other_date = ApplicationDate.new(2010, 9, 31)
    end
  end

  # TODO: Replace with a spec that integrates the classes above
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

describe "Employers should be able to see jobseekers who have applied to their jobs by both job and day" do
  describe "If possible, we would like to be able to combine the 2 and see jobseekers who have applied to a given job on a given day" do
    it "should have a way to filter down to just the applications for a specific job and a specific day" do
      @filtered_applications.size.should == 1
      @filtered_applications.include?(@application1).should be_true
      @filtered_applications.include?(@application2).should be_false
      @filtered_applications.include?(@application3).should be_false
      @filtered_applications.include?(@application4).should be_false
    end

    describe TextApplicantsReport do
      it "should report on just the applications for a specific job and a specific day" do
        report = TextApplicantsReport.new(@filtered_applications)
        report.render.should == "Jobseeker[Name: Andy Alpha]"
      end
    end

    before(:each) do
      @service = ApplicationService.new

      @job = posted_job
      @other_job = posted_job

      @date = ApplicationDate.new(2012, 12, 13)
      @other_date = ApplicationDate.new(2013, 5, 9)

      @jobseeker1 = applying_jobseeker(name: "Andy Alpha", apply_to_service: @service)
      @jobseeker2 = applying_jobseeker(name: "Betsy Beta", apply_to_service: @service)
      @jobseeker3 = applying_jobseeker(name: "Gary Gamma", apply_to_service: @service)
      @jobseeker4 = applying_jobseeker(name: "Debra Delta", apply_to_service: @service)

      @application1 = @jobseeker1.apply_to_job(job: @job, on_date: @date)
      @application2 = @jobseeker2.apply_to_job(job: @job, on_date: @other_date)
      @application3 = @jobseeker3.apply_to_job(job: @other_job, on_date: @date)
      @application4 = @jobseeker4.apply_to_job(job: @other_job, on_date: @other_date)

      @service.all_applications.size.should == 4

      job_filter = ApplicationsByJobFilter.new(@job)
      day_filter = ApplicationsByDateFilter.new(@date)
      @filtered_applications = @service.select_applications_filtered_by([job_filter, day_filter])
    end
  end
end

describe TextApplicationReport do
  it "is pending"
end
