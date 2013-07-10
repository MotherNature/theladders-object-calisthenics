$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'labels'
require 'job'
require 'recruiter'
require 'posting'
require 'jobseeker'
require 'pp'

Before do
  @recruiters = []
  @jobs = []
  @joblist = nil
  @postinglist = nil
  @job = nil
  @recruiter = nil
  @jobtypefactory = JobTypeFactory.new
end

Given(/^a Jobseeker with Name "(.*?)"$/) do |name|
  @jobseeker = Jobseeker.new(name: Name.new(name))
end

Given(/^an empty SavedJobRecordList$/) do
  @savedjobrecordlist = SavedJobRecordList.new
end

When(/^the Jobseeker saves the Job to the SavedJobRecordList$/) do
  @savedjobrecordlist.save_job_for_jobseeker(job: @job, jobseeker: @jobseeker)
end

Then(/^the SavedJobRecordList should contain the Job$/) do
  pending # express the regexp above with the code you wish you had
end

