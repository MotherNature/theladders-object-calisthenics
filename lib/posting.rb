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

class PostingList
  def initialize(postings=[])
    @postings = postings
  end

  def post_job(job: nil, posted_by: nil)
    posting = Posting.new(job: job, posted_by: posted_by)
    @postings.push(posting)
  end

  def postings_posted_by(recruiter)
    filtered_postings = @postings.select do |posting|
      posting.posted_by?(recruiter)
    end

    PostingList.new(filtered_postings)
  end

  def jobs_posted_by(recruiter)
    joblist = JobList.new
    filtered_postings = @postings.select do |posting|
      posting.posted_by?(recruiter)
    end
    
    filtered_postings.each do |posting|
      posting.add_job_to_joblist(joblist)
    end

    joblist
  end
end
