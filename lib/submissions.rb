class Submission
  include ApplicationListAppender
  include PostingListAppender

  def initialize(application: nil, posting: nil)
    @application = application
    @posting = posting
  end

  def submitted_for_posting?(posting)
    @posting == posting
  end

  def application_applied_to_by?(jobseeker)
    @application.applied_to_by?(jobseeker)
  end

  def submitted_for_application?(application)
    @application == application
  end

  def posting_posted_by_recruiter?(recruiter)
    @posting.posted_by_recruiter?(recruiter)
  end

  def add_jobseeker_to_jobseekerlist(jobseekerlist)
    @application.add_jobseeker_to_jobseekerlist(jobseekerlist)
  end
end

class SubmissionList < List
  def apply_application_to_posting(application: nil, posting: nil)
    submission = Submission.new(application: application, posting: posting)
    add(submission)
    submission
  end

  def submissions_submitted_for_posting(posting)
    select do |submission|
      submission.submitted_for_posting?(posting)
    end
  end

  def applications_submitted_for_posting(posting)
    applicationlist = ApplicationList.new

    each do |submission|
      submission.add_application_to_applicationlist(applicationlist)
    end

    applicationlist
  end

  def submissions_submitted_by(jobseeker)
    select do |submission|
      submission.application_applied_to_by?(jobseeker)
    end
  end

  def applications_submitted_by(jobseeker)
    applicationlist = ApplicationList.new

    each do |submission|
      submission.add_application_to_applicationlist(applicationlist)
    end

    applicationlist
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

  def apply_application_to_posting(application: nil, posting: nil)
    if(! valid_application_for_posting?(application: application, posting: posting))
      raise IncompatibleApplicationError.new("This Application is incompatible with this Posting. JobType mismatch?")
    end

    submission = @submissionlist.apply_application_to_posting(application: application, posting: posting)
    submission
  end

  def valid_application_for_posting?(application: nil, posting: nil)
    if posting.job_requires_resume?
      return application.has_resume?
    end
    return true
  end

  def submissions_submitted_for_application(application)
    @submissionlist.select do |submission|
      submission.submitted_for_application?(application)
    end
  end

  def applications_submitted_for_posting(posting)
    @submissionlist.applications_submitted_for_posting(posting)
  end
end

