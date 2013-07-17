require 'labels'
require 'jobs'
require 'recruiters'
require 'postings'

class JobPoster
  def initialize(recruiter: nil, postinglist:  nil)
    @recruiter = recruiter
    @postinglist = postinglist
  end

  def post_job(job)
    posting = Posting.new(job: job, posted_by: @recruiter)
    @postinglist.add(posting)
    posting
  end
end

class JobApplicationPreparer
  def initialize(jobseeker: nil, jobapplicationlist: nil)
    @jobseeker = jobseeker
    @jobapplicationlist = jobapplicationlist
  end

  def prepare_application(resume=nil)
    jobapplication = JobApplication.new(jobseeker: @jobseeker, resume: resume)
    @jobapplicationlist.add(jobapplication)
    jobapplication
  end
end

