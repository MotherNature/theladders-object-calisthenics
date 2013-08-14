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

require 'webrat'

RSpec.configure do |klass|
  klass.include Helpers
  klass.include Webrat::Methods
  klass.include Webrat::Matchers
end

describe HTMLJobseekerReport do
  it "should report on the jobseeker's name" do
    report = HTMLJobseekerReport.new(@jobseeker)
    html = report.render
    html.should have_selector('.jobseeker .name', :content => 'Betsy J. Basic')
  end

  before(:each) do
    @jobseeker = basic_jobseeker
  end
end
