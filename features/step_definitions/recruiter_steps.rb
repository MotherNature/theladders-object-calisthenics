$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'labels'
require 'recruiter'
require 'job'
require 'pp'

Before do
  @recruiters = []
  @jobs = []
  @joblist = nil
  @job = nil
  @recruiter = nil
end

Given(/^a Recruiter with Name "(.*?)"$/) do |name|
  @recruiter = Recruiter.new(name: Name.new("Jane Doe"))
end

Given(/^a first Recruiter with Name "(.*?)"$/) do |name|
  recruiter = Recruiter.new(name: Name.new(name))
  @recruiters[0] = recruiter
end

Given(/^a second Recruiter with Name "(.*?)"$/) do |name|
  recruiter = Recruiter.new(name: Name.new(name))
  @recruiters[1] = recruiter
end

Given(/^an empty JobList$/) do
  @joblist = JobList.new
end

When(/^the Recruiter posts a Job titled "(.*?)" of Type "(.*?)" to the JobList$/) do |title, type|
  @job = Job.new(title: Title.new(title), type: Type.new(type))
  @recruiter.postJobToList(job: @job, joblist: @joblist)
end

When(/^the first Recruiter posts a first Job to the JobList$/) do
  job = Job.new(title: Title.new("Example Title"), type: Type.new("Example Type"))
  @jobs[0] = job
  @recruiters[0].postJobToList(job: @jobs[0], joblist: @joblist)
end

When(/^the second Recruiter posts a second Job to the JobList$/) do
  job = Job.new(title: Title.new("Example Title"), type: Type.new("Example Type"))
  @jobs[1] = job
  @recruiters[1].postJobToList(job: @jobs[1], joblist: @joblist)
end

When(/^the Recruiter asks for a list of Jobs that they posted$/) do
  @new_joblist = @joblist.posted_by(@recruiter)
end

When(/^the first Recruiter asks for a list of Jobs that they posted$/) do
  @new_joblist = @joblist.posted_by(@recruiters[0])
end

Then(/^the JobList should contain a Job titled "(.*?)" of Type "(.*?)"$/) do |title, type|
  expect(@joblist.include?(@job)).to be_true
end

Then(/^the returned JobList should contain a Job titled "(.*?)" of Type "(.*?)"$/) do |arg1, arg2|
  expect(@new_joblist.include?(@job)).to be_true
end

Then(/^the returned JobList should only contain the first Job$/) do
  expect(@new_joblist.include?(@jobs[0])).to be_true
  expect(@new_joblist.include?(@jobs[1])).to be_false
end
