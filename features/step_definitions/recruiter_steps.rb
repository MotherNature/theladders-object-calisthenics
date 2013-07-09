$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'labels'
require 'recruiter'
require 'job'

Given(/^a Recruiter with Name "(.*?)"$/) do |name|
  @recruiter = Recruiter.new(name: Name.new("Jane Doe"))
end

Given(/^an empty JobList$/) do
  @joblist = JobList.new
end

When(/^the Recruiter posts a Job titled "(.*?)" of Type "(.*?)" to the JobList$/) do |title, type|
  @job = Job.new(title: Title.new(title), type: Type.new(type))
  @recruiter.postJobToList(job: @job, joblist: @joblist)
end

Then(/^the JobList should contain a Job titled "(.*?)" of Type "(.*?)"$/) do |title, type|
  expect(@joblist.include?(@job)).to be_true
end

