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
    answers = []

    if(filter.respond_to? :on_posted)
      passes = filter.on_posted(self.posted?)
      answers.push(passes)
    end

    if(filter.respond_to? :on_posted_by)
      passes = filter.on_posted_by(@poster)
      answers.push(passes)
    end

    answers.none? do |answer|
      answer == false
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

class JobList < List
end

class PostedJobFilter
  def on_posted(posted)
    posted
  end
end

class PostedByFilter
  def initialize(poster)
    @poster = poster
  end

  def on_posted_by(poster)
    @poster == poster
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

  def passes_filter?(filter)
    answers = []

    if(filter.respond_to? :on_posted_by)
      any_posted_by = false

      @applied_to.each do |job|
        if(job.passes_filter?(filter))
          any_posted_by = true
        end
      end

      answers.push(any_posted_by)
    end

    answers.none? do |passed|
      passed == false
    end
  end

  when_reporting :jobs do |reportable|
    @applied_to ||= JobList.new # TODO: Can I initialize this in just one place?

    @applied_to.each do |job|
      job.report_to(reportable)
    end
  end
end

