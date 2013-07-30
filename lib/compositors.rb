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

class ApplicationPreparer
  def initialize(jobseeker: nil, jobapplicationlist: nil)
    @jobseeker = jobseeker
    @jobapplicationlist = jobapplicationlist
  end

  def prepare_application(resume=nil)
    jobapplication = Application.new(jobseeker: @jobseeker, resume: resume)
    @jobapplicationlist.add(jobapplication)
    jobapplication
  end
end

class Submitter
  def initialize(jobapplication: nil, submissionservice: nil)
    @jobapplication = jobapplication
    @submissionservice = submissionservice
  end

  def submit_application(posting)
    submission = @submissionservice.apply_jobapplication_to_posting(jobapplication: @jobapplication, posting: posting)
    submission
  end
end

class SubmissionRecorder
  def initialize(submitter: nil, submissionrecordlist: nil)
    @submitter = submitter
    @submissionrecordlist = submissionrecordlist
  end
  
  def submit_application(posting)
    submission = @submitter.submit_application(posting)
    submissionrecord = SubmissionRecord.new(submission: submission, recorded_at_datetime: DateTime.new)
    @submissionrecordlist.add(submissionrecord)
    submissionrecord
  end
end
