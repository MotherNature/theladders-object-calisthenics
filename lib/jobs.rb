require 'utilities'
require 'job_utilities'
require 'posting_utilities'
require 'labels'
require 'reports'

class Job
  def initialize(title: nil, jobtype: nil)
    @title = title
    @jobtype = jobtype
  end

  def requires_resume?
    @jobtype.requires_resume?
  end

  def title_to_string
    @title.to_string
  end

  def jobtype_to_string
    @jobtype.to_string
  end
end

class JobFactory
  def initialize
    @jobtypefactory = JobTypeFactory.new
  end

  def build_job(title_string: nil, jobtype_string: nil)
    title = Title.new(title_string)
    jobtype = @jobtypefactory.build_jobtype(jobtype_string)
    Job.new(title: title, jobtype: jobtype)
  end
end

class SavedJobRecord
  include JobListAppender

  def initialize(job: nil, jobseeker: nil)
    @job = job
    @jobseeker = jobseeker
  end

  def saved_by?(jobseeker)
    @jobseeker == jobseeker
  end

  def job_title_to_string
    @job.title_to_string
  end
end

class JobList < List
  def posted_by(recruiter)
    select do |job|
      job.posted_by(recruiter)
    end
  end

  public
  # TODO: Replace exposed method with a more explicit verb.
  def add(job)
    super(job)
  end
end

class JobListReport < ListReport
  def to_string
    jobs = @list.to_array
    report_strings = jobs.map do |job|
      "Title: #{job.title_to_string}\nType: #{job.jobtype_to_string}"
    end
    report_strings.join("\n---\n")
  end
end

class JobListTitleReport < ListReport
  def to_string
    jobs = @list.to_array
    title_strings = jobs.map do |job|
      "Title: #{job.title_to_string}"
    end
    title_strings.join("\n")
  end
end

class JobListReportGenerator < ListReportGenerator
  def generate_from(joblist)
    JobListReport.new(joblist)
  end
  def generate_titles_from(joblist)
    JobListTitleReport.new(joblist)
  end
end

class JobApplication
  include JobListAppender

  def initialize(jobseeker: nil, resume: nil)
    if(! resume.nil? && ! resume.belongs_to?(jobseeker))
      raise InvalidJobApplicationError.new("The Resume does not belong to the Jobseeker")
    end

    @jobseeker = jobseeker
    @resume = resume
  end

  def applied_to_by?(jobseeker)
    @jobseeker == jobseeker
  end

  def has_resume?
    ! @resume.nil?
  end

  def has_this_resume?(resume)
    @resume == resume
  end
end

class JobApplicationList < List
  def jobseeker_applies_to_job(jobseeker: nil, job: nil)
    jobapplication = JobApplication.new(job: job, jobseeker: jobseeker)
    add(jobapplication)
  end

  def jobapplications_submitted_by(jobseeker)
    select do |jobapplication|
      jobapplication.applied_to_by?(jobseeker)
    end
  end

  def jobs_applied_to_by(jobseeker)
    select do |jobapplication|
      jobapplication.add_job_to_joblist(joblist)
    end
  end

  public
  # TODO: Replace exposed method with a more explicit verb.
  def add(job)
    super(job)
  end
end

class JobApplicationSubmission
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
end

class JobApplicationSubmissionList < List
  def apply_jobapplication_to_posting(jobapplication: nil, posting: nil)
    jobapplicationsubmission = JobApplicationSubmission.new(jobapplication: jobapplication, posting: posting)
    add(jobapplicationsubmission)
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
end

class JobApplicationSubmissionService
  def initialize(jobapplicationsubmissionlist: JobApplicationSubmissionList.new)
    @jobapplicationsubmissionlist = jobapplicationsubmissionlist
  end

  def apply_jobapplication_to_posting(jobapplication: nil, posting: nil)
    if(! valid_jobapplication_for_posting?(jobapplication: jobapplication, posting: posting))
      raise IncompatibleJobApplicationError.new("This JobApplication is incompatible with this Posting. JobType mismatch?")
    end

    @jobapplicationsubmissionlist.apply_jobapplication_to_posting(jobapplication: jobapplication, posting: posting)
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

class SavedJobRecordList < List
  def save_job_for_jobseeker(job: nil, jobseeker: nil)
    savedjobrecord = SavedJobRecord.new(job: job, jobseeker: jobseeker)
    add(savedjobrecord)
  end

  def records_saved_by(jobseeker)
    select do |savedjobrecord|
      savedjobrecord.saved_by?(jobseeker)
    end
  end

  def jobs_saved_by(jobseeker)
    joblist = JobList.new

    records_saved_by(jobseeker).each do |savedjobrecord|
      savedjobrecord.add_job_to_joblist(joblist)
    end

    joblist
  end
end

class SavedJobListReport < ListReport
  def to_string
    jobs = @list.to_array
    title_strings = jobs.map do |job|
      "Title: #{job.title_to_string}"
    end
    title_strings.join("\n")
  end
end

class SavedJobListReportGenerator < ListReportGenerator
  def generate_from(savedjoblist)
    SavedJobListReport.new(savedjoblist)
  end
end

class JobApplicationSubmissionRecord
  def initialize(jobapplication: nil, recorded_at_datetime: nil)
    @jobapplication = jobapplication
    @recorded_at_datetime = recorded_at_datetime
  end

  def recorded_at_datetime?(datetime)
    @recorded_at_datetime == datetime
  end
end
