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

describe ApplicationsByDateFilter do
  it "should filter down to only applications submitted on a given date" do
    filter = ApplicationsByDateFilter.new(@date)

    filtered_applications = @service.select_applications_filtered_by([filter])

    filtered_applications.size.should == 1
    filtered_applications.include?(@application1).should be_true
    filtered_applications.include?(@application2).should be_false
  end

  it "should filter down to only applications submitted on other given dates" do
    filter = ApplicationsByDateFilter.new(@other_date)

    filtered_applications = @service.select_applications_filtered_by([filter])

    filtered_applications.size.should == 1
    filtered_applications.include?(@application1).should be_false
    filtered_applications.include?(@application2).should be_true
  end

  before(:each) do
    @service = ApplicationService.new

    jobseeker = applying_jobseeker(apply_to_service: @service)

    job = posted_job
    other_job = posted_job(title: "Other Job")

    @date = ApplicationDate.new(2012, 12, 13)
    @other_date = ApplicationDate.new(2013, 5, 9)

    @application1 = jobseeker.apply_to_job(job: job, on_date: @date)
    @application2 = jobseeker.apply_to_job(job: other_job, on_date: @other_date)
  end
end


describe AnyPostedByFilter do
  # TODO: Swap filter language around
  # Example: employer.find_applications_for_my_jobs_in(application_list)
  describe JobseekerList do # TODO: Filter a SubmissionList instead of a JobseekerList
    it "should filter down to jobseekers who have applied to jobs posted by the given job-poster" do
      filtered_list = @service.select_applications_filtered_by([@posted_by])

      filtered_list.size.should == 1
      filtered_list.include?(@application).should be_true
      filtered_list.include?(@other_application).should be_false
    end

    it "should filter down to jobseekers who have applied to jobs posted by the given job-poster, even if they have applied to other posters' jobs" do
      new_application = @other_jobseeker.apply_to_job(job: @job)

      filtered_list = @service.select_applications_filtered_by([@posted_by])

      filtered_list.size.should == 2
      filtered_list.include?(@application).should be_true
      filtered_list.include?(new_application).should be_true
    end

    before(:each) do
      @service = ApplicationService.new
      @employer = posting_employer
      @job = posted_job(poster: @employer)

      @jobseeker = applying_jobseeker(apply_to_service: @service)
      @application = @jobseeker.apply_to_job(job: @job)

      @other_job = posted_job
      
      @other_jobseeker = applying_jobseeker(apply_to_service: @service)
      @other_application = @other_jobseeker.apply_to_job(job: @other_job)

      @posted_by = AnyPostedByFilter.new(@employer)
    end
  end
end

describe ApplicationsByEmployersJobsFilter do
  it "should filter down to only applications for jobs posted by the given employer" do
    @service.all_applications.size.should == 0

    application1 = @jobseeker1.apply_to_job(job: @job)
    application2 = @jobseeker2.apply_to_job(job: @job)
    application3 = @jobseeker3.apply_to_job(job: @other_job)

    filter = ApplicationsByEmployersJobsFilter.new(@employer)
    filtered_applications = @service.select_applications_filtered_by([filter])

    filtered_applications.size.should == 2
    filtered_applications.include?(application1).should be_true
    filtered_applications.include?(application2).should be_true
    filtered_applications.include?(application3).should be_false
  end

  before(:each) do
    @service = ApplicationService.new

    @employer = posting_employer(name: "Patrick Poster")
    @job = posted_job(poster: @employer)

    @other_employer = posting_employer(name: "Olive Other")
    @other_job = posted_job(poster: @other_employer)

    @jobseeker1 = applying_jobseeker(name: "Andy Alpha", apply_to_service: @service)
    @jobseeker2 = applying_jobseeker(name: "Betsy Beta", apply_to_service: @service)
    @jobseeker3 = applying_jobseeker(name: "Gary Gamma", apply_to_service: @service)
  end
end

describe ApplicationsByJobFilter do
  it "should filter down to only applications for the given job" do
    @service.all_applications.size.should == 0

    application1 = @jobseeker1.apply_to_job(job: @job)
    application2 = @jobseeker2.apply_to_job(job: @job)
    application3 = @jobseeker3.apply_to_job(job: @other_job)

    filter = ApplicationsByJobFilter.new(@job)
    filtered_applications = @service.select_applications_filtered_by([filter])

    filtered_applications.size.should == 2
    filtered_applications.include?(application1).should be_true
    filtered_applications.include?(application2).should be_true
    filtered_applications.include?(application3).should be_false
  end

  before(:each) do
    @service = ApplicationService.new

    @job = posted_job
    @other_job = posted_job

    @jobseeker1 = applying_jobseeker(name: "Andy Alpha", apply_to_service: @service)
    @jobseeker2 = applying_jobseeker(name: "Betsy Beta", apply_to_service: @service)
    @jobseeker3 = applying_jobseeker(name: "Gary Gamma", apply_to_service: @service)
  end
end

