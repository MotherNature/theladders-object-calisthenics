require 'utility'
require 'job_utilities'

class Job
  def initialize(title: nil, jobtype: nil)
    @title = title
    @jobtype = jobtype
  end

  def requires_resume?
    @jobtype.requires_resume?
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
    items_filtered_for(recruiter) do |job|
      job.posted_by(recruiter)
    end
  end
end

class JobApplication
  include JobListAppender

  def initialize(jobseeker: nil, resume: nil)
    @jobseeker = jobseeker
    @resume = resume
  end

  def applied_to_by?(jobseeker)
    @jobseeker == jobseeker
  end

  def has_resume?
    ! @resume.nil?
  end
end

class JobApplicationList < List
  def jobseeker_applies_to_job(jobseeker: nil, job: nil)
    jobapplication = JobApplication.new(job: job, jobseeker: jobseeker)
    add(jobapplication)
  end

  def jobapplications_submitted_by(jobseeker)
    items_filtered_for(jobseeker) do |jobapplication|
      jobapplication.applied_to_by?(jobseeker)
    end
  end

  def jobs_applied_to_by(jobseeker)
    items_filtered_for(jobseeker) do |jobapplication|
      jobapplication.add_job_to_joblist(joblist)
    end
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

class JobApplicationRecordList
  def initialize(jobapplicationrecords=[])
    @jobapplicationrecords = jobapplicationrecords
  end

  def each(&each_block)
    @jobapplicationrecords.each &each_block
  end

  def apply_jobapplication_to_job(jobapplication: nil, job: nil)
    jobapplicationrecord = JobApplicationRecord.new(jobapplication: jobapplication, job: job)
    @jobapplicationrecords.push(jobapplicationrecord)
  end

  def jobapplicationrecords_submitted_for_job(job)
    filtered_jobapplicationrecords = @jobapplicationrecords.select do |jobapplicationrecord|
      jobapplicationrecord.submitted_for_job?(job)
    end

    JobApplicationRecordList.new(filtered_jobapplicationrecords)
  end

  def jobapplications_submitted_for_job(job)
    jobapplicationlist = JobApplicationList.new

    jobapplicationrecords_submitted_for_job(job).each do |jobapplicationrecord|
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
      raise InvalidJobApplicationError.new
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

class SavedJobRecordList
  def initialize(savedjobrecords=[])
    @savedjobrecords = savedjobrecords
  end

  def save_job_for_jobseeker(job: nil, jobseeker: nil)
    savedjobrecord = SavedJobRecord.new(job: job, jobseeker: jobseeker)
    @savedjobrecords.push(savedjobrecord)
  end

  def records_saved_by(jobseeker)
    filtered_savedjobrecords = @savedjobrecords.select do |savedjobrecord|
      savedjobrecord.saved_by?(jobseeker)
    end

    SavedJobRecordList.new(filtered_savedjobrecords)
  end

  def each(&each_block)
    @savedjobrecords.each &each_block
  end

  def jobs_saved_by(jobseeker)
    joblist = JobList.new

    records_saved_by(jobseeker).each do |savedjobrecord|
      savedjobrecord.add_job_to_joblist(joblist)
    end

    joblist
  end
end
