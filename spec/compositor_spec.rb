$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'labels'
require 'jobs'
require 'jobseekers'
require 'recruiters'
require 'postings'
require 'resumes'
require 'examples'

describe JobPoster do
  before(:each) do
    examplefactory = ExampleFactory.new

    @recruiter = examplefactory.build_recruiter

    @job = examplefactory.build_job

    @posting = Posting.new(job: @job, posted_by: @recruiter)

    @postinglist = PostingList.new
  end

  describe "#post_job" do
    it "should return a Posting" do
      jobposter = JobPoster.new(recruiter: @recruiter, postinglist: @postinglist)

      jobposter.post_job(@job)
    end
  end
end
