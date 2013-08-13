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


describe PostedByFilter do
  describe JobseekerList do
    it "should filter down to jobseekers who have applied to jobs posted by the given job-poster" do
      filtered_list = @jobseekers.filtered_by([@posted_by])

      filtered_list.size.should == 1
      filtered_list.include?(@jobseeker).should be_true
      filtered_list.include?(@other_jobseeker).should be_false
    end

    it "should filter down to jobseekers who have applied to jobs posted by the given job-poster, even if they have applied to other posters' jobs" do
      @other_jobseeker.apply_to(job: @job)

      filtered_list = @jobseekers.filtered_by([@posted_by])

      filtered_list.size.should == 2
      filtered_list.include?(@jobseeker).should be_true
      filtered_list.include?(@other_jobseeker).should be_true
    end

    before(:each) do
      @employer = posting_employer
      @job = posted_job(poster: @employer)

      @jobseeker = applying_jobseeker
      @jobseeker.apply_to(job: @job)

      @other_job = posted_job
      
      @other_jobseeker = applying_jobseeker
      @other_jobseeker.apply_to(job: @other_job)

      @jobseekers = JobseekerList.new([@jobseeker, @other_jobseeker])

      @posted_by = PostedByFilter.new(@employer)
    end
  end
end
