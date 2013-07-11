$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

require 'labels'
require 'recruiter'
require 'posting'
require 'job'

jobtypefactory = JobTypeFactory.new

describe Recruiter do
  before(:each) do
    @recruiter = Recruiter.new(name: Name.new("Rachel McExample"))
    @postinglist = PostingList.new
  end

  describe "Post Jobs" do
    it "should be able to a post simple ATS job" do
      title = Title.new("Example Job Title")
      job = Job.new(title: Title.new(title), jobtype: jobtypefactory.build_jobtype("ATS"))
      @postinglist.post_job(job: job, posted_by: @recruiter)

      @postinglist.jobs_posted_by(@recruiter).should include job
    end
  end
end
