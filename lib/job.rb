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

class JobList
  def initialize(jobs=[])
    @jobs = jobs
  end

  def add(job)
    @jobs.push job
  end
  
  def include?(job)
    @jobs.include?(job)
  end

  def posted_by(recruiter)
    filtered_jobs = @jobs.select do |job|
      job.posted_by(recruiter)
    end

    JobList.new(filtered_jobs)
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
