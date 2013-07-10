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
  @jobapplicationlist = nil
end

Given(/^a Jobseeker with Name "(.*?)"$/) do |name|
  @jobseeker = Jobseeker.new(name: Name.new(name))
end

Given(/^an empty SavedJobRecordList$/) do
  @savedjobrecordlist = SavedJobRecordList.new
end

Given(/^an empty JobApplicationList$/) do
  @jobapplicationlist = JobApplicationList.new
end

Given(/^an empty JobApplicationRecordList$/) do
  pending
end

When(/^the Jobseeker saves the Job to the SavedJobRecordList$/) do
  @savedjobrecordlist.save_job_for_jobseeker(job: @job, jobseeker: @jobseeker)
end

Then(/^the SavedJobRecordList should contain the Job$/) do
  @savedjobrecordlist.jobs_saved_by(@jobseeker).should include @job
end

When(/^the Jobseeker applies to the Job$/) do
  @jobapplicationlist.jobseeker_applies_to_job(jobseeker: @jobseeker, job: @job)
end

Then(/^the JobApplicationList should list the Job as applied to by the Jobseeker$/) do
  @jobapplicationlist.jobs_applied_to_by(@jobseeker).should include @job
end

Then(/^the JobApplicationRecordList should throw an "(.*?)" exception$/) do |exception_description|
  pending # express the regexp above with the code you wish you had
end
