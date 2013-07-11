require 'job_utilities'

class Posting
  include JobListAppender

  def initialize(job: nil, posted_by: posted_by)
    @job = job
    @posted_by = posted_by
  end

  def posted_by?(recruiter)
    @posted_by == recruiter
  end
end

class PostingList < List
  def post_job(job: nil, posted_by: nil)
    posting = Posting.new(job: job, posted_by: posted_by)
    add(posting)
  end

  def postings_posted_by(recruiter)
    select do |posting|
      posting.posted_by?(recruiter)
    end
  end

  def jobs_posted_by(recruiter)
    joblist = JobList.new

    postings_posted_by(recruiter).each do |posting|
      posting.add_job_to_joblist(joblist)
    end

    joblist
  end
end
