$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'labels'
require 'job'
require 'recruiter'
require 'posting'
require 'jobseeker'
require 'pp'

error_message_and_error_class_associations = {
  "Invalid JobApplication" => InvalidJobApplicationError
}

Before do
  @recruiters = []
  @jobs = []
  @joblist = nil
  @postinglist = nil
  @job = nil
  @recruiter = nil
  @jobtypefactory = JobTypeFactory.new
  @jobapplicationlist = nil
  @jobapplicationrecordservice = nil
  @jobapplication = nil
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

Given(/^an empty JobApplicationRecordService$/) do
  @jobapplicationrecordservice = JobApplicationRecordService.new
end

When(/^the Jobseeker saves the Job to the SavedJobRecordList$/) do
  @savedjobrecordlist.save_job_for_jobseeker(job: @job, jobseeker: @jobseeker)
end

Then(/^the SavedJobRecordList should contain the Job$/) do
  @savedjobrecordlist.jobs_saved_by(@jobseeker).should include @job
end

When(/^the Jobseeker applies to the Job with a JobApplication$/) do
  @jobapplication = JobApplication.new(jobseeker: @jobseeker)
  @jobapplicationrecordservice.apply_jobapplication_to_job(jobapplication: @jobapplication, job: @job)
end

Then(/^the JobApplicationRecordService should include the JobApplication$/) do
  @jobapplicationrecordservice.jobapplications_submitted_for_job(@job).should include @jobapplication
end

Then(/^the JobApplicationRecordService should throw an "(.*?)" error when the Jobseeker applies to the Job with the JobApplication$/) do |error_message|
  error_class = error_message_and_error_class_associations[error_message]
  @jobapplication = JobApplication.new(jobseeker: @jobseeker)
  expect { @jobapplicationrecordservice.apply_jobapplication_to_job(jobapplication: @jobapplication, job: @job) }.to raise_error(error_class)
end
