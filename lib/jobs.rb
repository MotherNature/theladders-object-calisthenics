require 'utilities'
require 'reports'

class JobType
  class ATS
    def suitable_resume?(resume)
      ! resume.exists?
    end
  end

  class JReq
    def suitable_resume?(resume)
      resume.exists?
    end
  end

  def self.ATS
    ATS.new
  end

  def self.JReq
    JReq.new
  end
end

class UnpostedJob
  include Reports

  when_reporting :job_title do
    @title
  end

  def initialize(title: nil, type: nil)
    @title = title
    @type = type
  end

  def suitable_resume?(resume)
    @type.suitable_resume?(resume)
  end

  def posted?
    false
  end
end

class PostedJob < SimpleDelegator
  include HumanReadableDelegation
  include Reports

  def initialize(job: nil, posted_by: nil)
    super(job)
    @poster = posted_by
  end

  def report(reportable)
    redirectee.report(reportable)
    @poster.report(reportable)
  end

  def posted?
    true
  end

  def posted_by?(poster)
    @poster == poster
  end
end

class SavedJob < SimpleDelegator
  include HumanReadableDelegation

  def initialize(job: nil)
    super(job)
  end

  def report(reportable)
    if(reportable.respond_to?(:report_saved_job))
      redirectee.report(reportable)
    end
  end
end

class JobList
  def initialize(jobs=[])
    @jobs = jobs
  end

  def each(&block)
    @jobs.each(&block)
  end

  def select(&block)
    filtered_jobs = @jobs.select(&block)
    JobList.new(filtered_jobs)
  end

  def with(job)
    JobList.new([*@jobs, job])
  end

  def report(reportable)
    self.each do |job|
      job.report(reportable)
    end
  end
end

class PostedJobList < JobList
  def self.filtered_from(joblist)
    filtered_list = joblist.each do |job|
      job.posted?
    end
    PostedJobList.new(filtered_list)
  end
end

module JobPoster
  def post_job(job)
    PostedJob.new(job: job, posted_by: self)
  end
end

class JobSaver < RoleDelegator
  def initialize(role_filler)
    super(role_filler)
    @jobs = JobList.new
  end

  def save_job(job)
    savedjob = SavedJob.new(job: job)
    @jobs = @jobs.with(savedjob)
  end

  def report(reportable)
    @jobs.each do |job|
      job.report(reportable)
    end
  end
end
