$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'labels'
require 'recruiter'
require 'job'
require 'posting'
require 'pp'

Before do
  @recruiters = []
  @jobs = []
  @joblist = nil
  @postinglist = nil
  @job = nil
  @recruiter = nil
end

Given(/^a Recruiter with Name "(.*?)"$/) do |name|
  @recruiter = Recruiter.new(name: Name.new(name))
end

Given(/^a first Recruiter with Name "(.*?)"$/) do |name|
  recruiter = Recruiter.new(name: Name.new(name))
  @recruiters[0] = recruiter
end

Given(/^a second Recruiter with Name "(.*?)"$/) do |name|
  recruiter = Recruiter.new(name: Name.new(name))
  @recruiters[1] = recruiter
end

Given(/^an empty PostingList$/) do
  @postinglist = PostingList.new
end

When(/^the Recruiter posts a Job titled "(.*?)" of Type "(.*?)" to the PostingList$/) do |title, type|
  @job = Job.new(title: Title.new(title), type: Type.new(type), posted_by: @recruiter)
  @postinglist.post_job(job: @job, posted_by: @recruiter)
end

When(/^the first Recruiter posts the first Job to the PostingList$/) do
  job = Job.new(title: Title.new("Example Title"), type: Type.new("Example Type"), posted_by: @recruiters[0])
  @jobs[0] = job
  @postinglist.post_job(job: @jobs[0], posted_by: @recruiters[0])
end

When(/^the second Recruiter posts the second Job to the PostingList$/) do
  job = Job.new(title: Title.new("Example Title"), type: Type.new("Example Type"), posted_by: @recruiters[1])
  @jobs[1] = job
  @postinglist.post_job(job: @jobs[1], posted_by: @recruiters[1])
end

When(/^the first Recruiter asks for a list of Jobs that they posted$/) do
  @new_joblist = @postinglist.jobs_posted_by(@recruiters[0])
end

Then(/^the PostingList should contain a Posting of the Job by the Recruiter$/) do
  @postinglist.jobs_posted_by(@recruiter).should include @job
end

Then(/^the returned JobList should only contain the first Job$/) do
  @new_joblist.should include @jobs[0]
  @new_joblist.should_not include @jobs[1]
end
