$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'jobs'
require 'jobseekers'
require 'employers'
require 'submissions'

require 'helpers'

RSpec.configure do |klass|
  klass.include Helpers
end

describe "Jobseekers can save jobs onsite for later viewing" do
  before(:each) do
    @jobseeker = saving_jobseeker

    @job = posted_job
  end

  describe Jobseeker do
    it "should be able to save a list of jobs" do
      @jobseeker.save_job(@job)
    end
  end
end
