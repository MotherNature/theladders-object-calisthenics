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

