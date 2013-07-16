require 'utilities'
require 'job_utilities'
require 'reports'

class Posting
  include JobListAppender

  def initialize(job: nil, posted_by: posted_by)
    @job = job
    @posted_by = posted_by
  end

  # TODO: refactor to use posted_by_recruiter? everywhere
  def posted_by?(recruiter)
    @posted_by == recruiter
  end

  def posted_by_recruiter?(recruiter)
    posted_by?(recruiter)
  end

  def job_title_to_string
    @job.title_to_string
  end

  def recruiter_name_to_string
    @posted_by.name_to_string
  end

  def job_requires_resume?
    @job.requires_resume?
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

  public
  # TODO: Replace exposed method with a more explicit verb.
  def add(job)
    super(job)
  end
end

class PostingListReport < ListReport
  def to_string
    postings = @list.to_array
    report_strings = postings.map do |posting|
      "Job Title: #{posting.job_title_to_string}\nRecruiter: #{posting.recruiter_name_to_string}"
    end
    report_strings.join("\n---\n")
  end
end

class PostingListReportGenerator < ListReportGenerator
  def generate_from(list)
    PostingListReport.new(list)
  end
end

