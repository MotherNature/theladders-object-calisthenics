require 'ostruct'

require 'utilities'
require 'reports'

class UnpostedJob
  include Reports

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

  def posted_by?(poster)
    false
  end

  def as_reportable
    OpenStruct.new(title: @title.as_reportable, posted: posted?)
  end

  when_reporting :job_title do |reportable|
    @title.report_title_to(reportable)
  end
end

class PostedJob < SimpleDelegator
  include HumanReadableDelegation
  include Reports

  def initialize(job: nil, posted_by: nil)
    super(job)
    @poster = posted_by
  end

  def report_to(reportable)
    delegatee.report_to(reportable)
    @poster.report_to(reportable)
  end

  def posted?
    true
  end

  def posted_by?(poster)
    @poster == poster
  end

  def as_reportable
    reportable = super
    reportable.posted = posted?
    reportable.poster = @poster.as_reportable
    reportable
  end
end

class SavedJob < SimpleDelegator
  include HumanReadableDelegation

  def initialize(job: nil, saved_by: nil)
    super(job)
    @saved_by = saved_by
  end

  def report_to(reportable)
    if(reportable.respond_to?(:report_saved_jobs))
      delegatee.report_to(reportable)
    end
  end
end

class JobList < List
  def as_reportable
    job_reportables = self.map do |job|
      job.as_reportable
    end
    OpenStruct.new(jobs: job_reportables)
  end
end

class PostedJobFilter
  def filter_by_posted(posted)
    posted == true
  end

  def allows?(job)
    job.posted?
  end
end

class PostedByFilter
  def initialize(poster)
    @poster = poster
  end

  def passing_poster?(poster)
    @poster == poster
  end

  def filter_by_posted_by(was_posted)
    was_posted
  end

  def allows?(job)
    job.posted_by?(@poster)
  end
end

class AnyPostedByFilter
  def initialize(poster)
    @poster = poster
  end

  def filter_jobs(jobs)
    filter = PostedByFilter.new(@poster)
    jobs.select do |job|
      job.passes_filter?(filter)
    end
  end

  def filter_by_jobs(any_jobs)
    any_jobs
  end

  def allows?(application)
    application.posted_by?(@poster)
  end
end

module JobPoster
  def post_job(job)
    posted_job = PostedJob.new(job: job, posted_by: self)
  end
end

class JobSaverRole < Role
  def initialize(save_to_repo: nil)
    @repo = save_to_repo 
    super(nil)
  end

  def save_job(job)
    savedjob = SavedJob.new(job: job, saved_by: self)
    @repo.add_job(savedjob)
  end
end

class JobRepo
  def initialize
    @jobs = JobList.new
  end

  def add_job(job)
    @jobs = @jobs.with(job)
  end

  def contents_as_reportable
    @jobs.as_reportable
  end
end

