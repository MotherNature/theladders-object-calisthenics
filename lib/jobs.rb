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

  def passes_filter?(filter)
    if(filter.respond_to? :on_posted)
      filter.on_posted(self.posted?)
    end
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
    redirectee.report_to(reportable)
    @poster.report_to(reportable)
  end

  def posted?
    true
  end

  def posted_by?(poster)
    @poster == poster
  end

  def passes_filter?(filter)
    if(filter.respond_to? :on_posted)
      filter.on_posted(self.posted?)
    end
  end
end

class SavedJob < SimpleDelegator
  include HumanReadableDelegation

  def initialize(job: nil)
    super(job)
  end

  def report_to(reportable)
    if(reportable.respond_to?(:report_saved_jobs))
      redirectee.report_to(reportable)
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

  def filtered_by(filters)
    filtered_jobs = @jobs.select do |job|
      filters.any? do |filter|
        job.passes_filter?(filter)
      end
    end
    JobList.new(filtered_jobs)
  end

  def any?(&block)
    filtered_list = select(&block)
    filtered_list.size > 0
  end

  def size
    @jobs.size
  end

  def with(job)
    JobList.new([*@jobs, job])
  end

  def report_to(reportable)
    self.each do |job|
      job.report_to(reportable)
    end
  end
end

class PostedJobFilter
  def self.on_posted(posted)
    posted
  end
end

module JobPoster
  def post_job(job)
    posted_job = PostedJob.new(job: job, posted_by: self)
  end
end

module JobSaver
  include Reports

  def save_job(job)
    @saved_jobs ||= JobList.new
    savedjob = SavedJob.new(job: job)
    @saved_jobs = @saved_jobs.with(savedjob)
  end

  when_reporting :jobs do |reportable|
    @saved_jobs ||= JobList.new

    @saved_jobs.each do |job|
      job.report_to(reportable)
    end
  end
end

module JobApplier
  include Reports

  def apply_to(job: nil, with_resume: NoResume)
    @applied_to ||= JobList.new # TODO: Can I initialize this in just one place?

    if(with_resume.exists? && ! with_resume.belongs_to?(self))
      return WrongJobseekersResumeSubmission.new(with_resume: with_resume, submitted_to: job)
    end

    # TODO: should the validation happen here instead of the Submission class?
    submission = Submission.new(with_resume: with_resume, submitted_to: job)

    if(submission.valid?)
      @applied_to = @applied_to.with(job)
    end

    submission
  end

  def applied_to_jobs_posted_by?(jobposter)
    @applied_to ||= JobList.new # TODO: Can I initialize this in just one place?

    @applied_to.any? do |job|
      job.posted? && job.posted_by?(jobposter)
    end
  end

  when_reporting :jobs do |reportable|
    @applied_to ||= JobList.new # TODO: Can I initialize this in just one place?

    @applied_to.each do |job|
      job.report_to(reportable)
    end
  end
end

