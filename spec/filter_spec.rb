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
