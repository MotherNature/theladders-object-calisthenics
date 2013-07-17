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
