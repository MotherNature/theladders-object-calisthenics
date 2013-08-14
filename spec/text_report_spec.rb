
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

describe "Jobs, when displayed, should be displayed with a title and the name of the employer who posted it" do
  describe TextPostedJobReport do
    it "should list the job title and the name of the employer that posted it" do
      @report.render.should == "Job[Title: A Job][Employer: Erin Employ]"
    end

    before(:each) do
      @report = TextPostedJobReport.new(posted_job)
    end
  end
end
