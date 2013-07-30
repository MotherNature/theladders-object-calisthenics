$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

require 'labels'
require 'recruiters'
require 'postings'
require 'jobs'

jobtypefactory = JobTypeFactory.new

describe Recruiter do
  before(:each) do
    @postinglist = PostingList.new
    @idnumberservice = IDNumberService.new
  end

  describe "Post Jobs" do
    before(:each) do
      @recruiter = Recruiter.new(name: Name.new("Rachel McExample"), idnumber: @idnumberservice.generate_idnumber)
    end

    it "should be able to post a simple ATS Job" do
      title = Title.new("Example Job Title")
      job = Job.new(title: Title.new(title), jobtype: jobtypefactory.build_jobtype("ATS"))
      @postinglist.post_job(job: job, posted_by: @recruiter)

      @postinglist.jobs_posted_by(@recruiter).should include job
    end

    it "should be able to post a simple JReq Job" do
      title = Title.new("Example Job Title")
      job = Job.new(title: Title.new(title), jobtype: jobtypefactory.build_jobtype("JReq"))
      @postinglist.post_job(job: job, posted_by: @recruiter)

      @postinglist.jobs_posted_by(@recruiter).should include job
    end
  end

  describe "List Jobs" do
    before(:each) do
      title = "Example Title"
      jobtype = "ATS"

      @recruiter1 = Recruiter.new(name: Name.new("Rachel McExample"), idnumber: @idnumberservice.generate_idnumber)
      @recruiter2 = Recruiter.new(name: Name.new("Jake Sample"), idnumber: @idnumberservice.generate_idnumber)
      @job1 = Job.new(title: Title.new(title), jobtype: jobtypefactory.build_jobtype(jobtype))
      @job2 = Job.new(title: Title.new(title), jobtype: jobtypefactory.build_jobtype(jobtype))

      @postinglist.post_job(job: @job1, posted_by: @recruiter1)
      @postinglist.post_job(job: @job2, posted_by: @recruiter2)
    end

    it "should be able to fetch a List of only those Jobs submitted by itself" do
      filtered_joblist = @postinglist.jobs_posted_by(@recruiter1).should include @job1
      filtered_joblist = @postinglist.jobs_posted_by(@recruiter2).should_not include @job1
    end
  end
end
