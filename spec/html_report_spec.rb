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

describe HTMLJobseekerListReport do
  it "should report on all the jobseekers' names" do
    report = HTMLJobseekerListReport.new(@jobseekers)
    html = report.render

    html.should have_selector('.jobseeker .name', :content => 'Betsy J. Basic')
    html.should have_selector('.jobseeker .name', :content => 'Anne Ditional')
  end

  it "should report on all the jobseekers' names, including just-added jobseekers" do
    new_jobseeker = basic_jobseeker(name: "Teresa Third")

    expanded_list = @jobseekers.with(new_jobseeker)

    report = HTMLJobseekerListReport.new(expanded_list)
    html = report.render

    html.should have_selector('.jobseeker .name', :content => 'Betsy J. Basic')
    html.should have_selector('.jobseeker .name', :content => 'Anne Ditional')
    html.should have_selector('.jobseeker .name', :content => 'Teresa Third')
  end

  it "should report on all the jobseekers' names for a fresh list of jobseekers" do
    new_jobseeker = basic_jobseeker(name: "Freda First")

    new_list = JobseekerList.new([new_jobseeker])

    report = HTMLJobseekerListReport.new(new_list)
    html = report.render

    html.should have_selector('.jobseeker .name', :content => 'Freda First')
    html.should_not have_selector('.jobseeker .name', :content => 'Anne Ditional')
    html.should_not have_selector('.jobseeker .name', :content => 'Teresa Third')
  end

  before(:each) do
    jobseeker1 = basic_jobseeker
    jobseeker2 = basic_jobseeker(name: "Anne Ditional")
    @jobseekers = JobseekerList.new([jobseeker1, jobseeker2])
  end
end

describe HTMLJobReport do
  it "should report on the job's title" do
    report = HTMLJobReport.new(@job)
    html = report.render

    html.should have_selector('.job .title', :content => 'A Job')
  end

  before(:each) do
    @job = unposted_job
  end
end
