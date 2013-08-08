$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'jobs'
require 'jobseekers'
require 'employers'
require 'submissions'

describe "Jobseekers can save jobs onsite for later viewing" do
  before(:each) do
    @jobseeker = Jobseeker.new
    @jobseeker = JobSaver.with_role_performed_by(@jobseeker)

    employer = Employer.new(name: "Erin Employ")
    employer.take_on_role(JobPoster)

    unposted_job = UnpostedJob.new(title: "A Job", type: JobType.ATS)

    @job = employer.post_job(unposted_job)
  end

  describe Jobseeker do
    it "should be able to save a list of jobs" do
      @jobseeker.save_job(@job)
    end
  end
end
