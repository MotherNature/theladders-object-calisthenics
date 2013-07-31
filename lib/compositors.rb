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
  def initialize(jobseeker: nil, applicationlist: nil)
    @jobseeker = jobseeker
    @applicationlist = applicationlist
  end

  def prepare_application(resume=nil)
    application = Application.new(jobseeker: @jobseeker, resume: resume)
    @applicationlist.add(application)
    application
  end
end

class Submitter
  def initialize(application: nil, submissionservice: nil)
    @application = application
    @submissionservice = submissionservice
  end

  def submit_application(posting: posting)
    submission = @submissionservice.apply_application_to_posting(application: @application, posting: posting)
    submission
  end
end

class SubmissionRecorder
  def initialize(submitter: nil, submissionrecordlist: nil)
    @submitter = submitter
    @submissionrecordlist = submissionrecordlist
  end
  
  def submit_application(posting: nil, date: DateTime.now)
    submission = @submitter.submit_application(posting: posting)
    submissionrecord = SubmissionRecord.new(submission: submission, recorded_at_datetime: date)
    @submissionrecordlist.add(submissionrecord)
    submissionrecord
  end
end
