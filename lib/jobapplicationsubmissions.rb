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
    jobapplicationsubmission = Submission.new(jobapplication: jobapplication, posting: posting)
    add(jobapplicationsubmission)
    jobapplicationsubmission
  end

  def jobapplicationsubmissions_submitted_for_posting(posting)
    select do |jobapplicationsubmission|
      jobapplicationsubmission.submitted_for_posting?(posting)
    end
  end

  def jobapplications_submitted_for_posting(posting)
    jobapplicationlist = JobApplicationList.new

    each do |jobapplicationsubmission|
      jobapplicationsubmission.add_jobapplication_to_jobapplicationlist(jobapplicationlist)
    end

    jobapplicationlist
  end

  def jobapplicationsubmissions_submitted_by(jobseeker)
    select do |jobapplicationsubmission|
      jobapplicationsubmission.jobapplication_applied_to_by?(jobseeker)
    end
  end

  def jobapplications_submitted_by(jobseeker)
    jobapplicationlist = JobApplicationList.new

    each do |jobapplicationsubmission|
      jobapplicationsubmission.add_jobapplication_to_jobapplicationlist(jobapplicationlist)
    end

    jobapplicationlist
  end

  def postings_submitted_to_by_jobseeker(jobseeker)
    postinglist = PostingList.new

    filtered_jobapplicationsubmissions = jobapplicationsubmissions_submitted_by(jobseeker)
    
    filtered_jobapplicationsubmissions.each do |jobapplicationsubmission|
      jobapplicationsubmission.add_posting_to_postinglist(postinglist)
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
    postinglist = select do |jobapplicationsubmission|
      jobapplicationsubmission.posting_submitted_by?(recruiter)
    end

    joblist = JobList.new

    postinglist.each do |posting|
      posting.add_job_to_joblist(joblist)
    end

    joblist
  end
end

class SubmissionService
  def initialize(jobapplicationsubmissionlist: SubmissionList.new)
    @jobapplicationsubmissionlist = jobapplicationsubmissionlist
  end

  def apply_jobapplication_to_posting(jobapplication: nil, posting: nil)
    if(! valid_jobapplication_for_posting?(jobapplication: jobapplication, posting: posting))
      raise IncompatibleJobApplicationError.new("This JobApplication is incompatible with this Posting. JobType mismatch?")
    end

    jobapplicationsubmission = @jobapplicationsubmissionlist.apply_jobapplication_to_posting(jobapplication: jobapplication, posting: posting)
    jobapplicationsubmission
  end

  def valid_jobapplication_for_posting?(jobapplication: nil, posting: nil)
    if posting.job_requires_resume?
      return jobapplication.has_resume?
    end
    return true
  end

  def jobapplicationsubmissions_submitted_for_jobapplication(jobapplication)
    @jobapplicationsubmissionlist.select do |jobapplicationsubmission|
      jobapplicationsubmission.submitted_for_jobapplication?(jobapplication)
    end
  end

  def jobapplications_submitted_for_posting(posting)
    @jobapplicationsubmissionlist.jobapplications_submitted_for_posting(posting)
  end
end

