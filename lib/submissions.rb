class Submission
  include JobApplicationListAppender
  include PostingListAppender

  def initialize(jobapplication: nil, posting: nil)
    @jobapplication = jobapplication
    @posting = posting
  end

  def submitted_for_posting?(posting)
    @posting == posting
  end

  def jobapplication_applied_to_by?(jobseeker)
    @jobapplication.applied_to_by?(jobseeker)
  end

  def submitted_for_jobapplication?(jobapplication)
    @jobapplication == jobapplication
  end

  def posting_posted_by_recruiter?(recruiter)
    @posting.posted_by_recruiter?(recruiter)
  end

  def add_jobseeker_to_jobseekerlist(jobseekerlist)
    @jobapplication.add_jobseeker_to_jobseekerlist(jobseekerlist)
  end
end

class SubmissionList < List
  def apply_jobapplication_to_posting(jobapplication: nil, posting: nil)
    submission = Submission.new(jobapplication: jobapplication, posting: posting)
    add(submission)
    submission
  end

  def submissions_submitted_for_posting(posting)
    select do |submission|
      submission.submitted_for_posting?(posting)
    end
  end

  def jobapplications_submitted_for_posting(posting)
    jobapplicationlist = JobApplicationList.new

    each do |submission|
      submission.add_jobapplication_to_jobapplicationlist(jobapplicationlist)
    end

    jobapplicationlist
  end

  def submissions_submitted_by(jobseeker)
    select do |submission|
      submission.jobapplication_applied_to_by?(jobseeker)
    end
  end

  def jobapplications_submitted_by(jobseeker)
    jobapplicationlist = JobApplicationList.new

    each do |submission|
      submission.add_jobapplication_to_jobapplicationlist(jobapplicationlist)
    end

    jobapplicationlist
  end

  def postings_submitted_to_by_jobseeker(jobseeker)
    postinglist = PostingList.new

    filtered_submissions = submissions_submitted_by(jobseeker)
    
    filtered_submissions.each do |submission|
      submission.add_posting_to_postinglist(postinglist)
    end

    postinglist
  end

  def jobs_submitted_to_by_jobseeker(jobseeker)
    postinglist = postings_submitted_to_by_jobseeker(jobseeker)

    joblist = JobList.new

    postinglist.each do |posting|
      posting.add_job_to_joblist(joblist)
    end

    joblist
  end

  def jobs_posted_by(recruiter)
    postinglist = select do |submission|
      submission.posting_submitted_by?(recruiter)
    end

    joblist = JobList.new

    postinglist.each do |posting|
      posting.add_job_to_joblist(joblist)
    end

    joblist
  end
end

class SubmissionService
  def initialize(submissionlist: SubmissionList.new)
    @submissionlist = submissionlist
  end

  def apply_jobapplication_to_posting(jobapplication: nil, posting: nil)
    if(! valid_jobapplication_for_posting?(jobapplication: jobapplication, posting: posting))
      raise IncompatibleJobApplicationError.new("This JobApplication is incompatible with this Posting. JobType mismatch?")
    end

    submission = @submissionlist.apply_jobapplication_to_posting(jobapplication: jobapplication, posting: posting)
    submission
  end

  def valid_jobapplication_for_posting?(jobapplication: nil, posting: nil)
    if posting.job_requires_resume?
      return jobapplication.has_resume?
    end
    return true
  end

  def submissions_submitted_for_jobapplication(jobapplication)
    @submissionlist.select do |submission|
      submission.submitted_for_jobapplication?(jobapplication)
    end
  end

  def jobapplications_submitted_for_posting(posting)
    @submissionlist.jobapplications_submitted_for_posting(posting)
  end
end

