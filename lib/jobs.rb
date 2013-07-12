require 'utilities'
require 'job_utilities'
require 'labels'

class Job
  def initialize(title: nil, jobtype: nil)
    @title = title
    @jobtype = jobtype
  end

  def requires_resume?
    @jobtype.requires_resume?
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

  def to_array
    super
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

class JobApplicationRecord
  include JobApplicationListAppender

  def initialize(jobapplication: nil, job: nil)
    @jobapplication = jobapplication
    @job = job
  end

  def submitted_for_job?(job)
    @job == job
  end
end

class JobApplicationRecordList < List
  def apply_jobapplication_to_job(jobapplication: nil, job: nil)
    jobapplicationrecord = JobApplicationRecord.new(jobapplication: jobapplication, job: job)
    add(jobapplicationrecord)
  end

  def jobapplicationrecords_submitted_for_job(job)
    select do |jobapplicationrecord|
      jobapplicationrecord.submitted_for_job?(job)
    end
  end

  def jobapplications_submitted_for_job(job)
    jobapplicationlist = JobApplicationList.new

    select do |jobapplicationrecord|
      jobapplicationrecord.add_jobapplication_to_jobapplicationlist(jobapplicationlist)
    end

    jobapplicationlist
  end
end

class JobApplicationRecordService
  def initialize(jobapplicationrecordlist: JobApplicationRecordList.new)
    @jobapplicationrecordlist = jobapplicationrecordlist
  end

  def apply_jobapplication_to_job(jobapplication: nil, job: nil)
    if(! valid_jobapplication_for_job?(jobapplication: jobapplication, job: job))
      raise IncompatibleJobApplicationError.new("This JobApplication is incompatible with this Job. JobType mismatch?")
    end

    @jobapplicationrecordlist.apply_jobapplication_to_job(jobapplication: jobapplication, job: job)
  end

  def valid_jobapplication_for_job?(jobapplication: nil, job: nil)
    if job.requires_resume?
      return jobapplication.has_resume?
    end
    return true
  end

  def jobapplications_submitted_for_job(job)
    @jobapplicationrecordlist.jobapplications_submitted_for_job(job)
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
