require 'ostruct'

require 'utilities'
require 'reports'

class UnpostedJob
  include Reports
  include Filterable

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

  def as_reportable
    OpenStruct.new(title: @title.as_reportable, posted: posted?)
  end

  when_filtering_by :posted do |filter|
    self.posted?
  end

  when_reporting :job_title do |reportable|
    @title.report_title_to(reportable)
  end
end

class PostedJob < SimpleDelegator
  include HumanReadableDelegation
  include Reports
  include Filterable

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

  def as_reportable
    reportable = super
    reportable.posted = posted?
    reportable.poster = @poster.as_reportable
    reportable
  end

  when_filtering_by :posted do |filter|
    self.posted?
  end

  when_filtering_by :posted_by do |filter|
    filter.passing_poster?(@poster)
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

class JobApplierRole < Role
  def initialize(apply_to_service: nil)
    @service = apply_to_service
  end

  def apply_to_job(job: nil, with_resume: NoResume) # TODO: Change back to just #apply_to after refactoring.
    if(with_resume.exists? && ! with_resume.belongs_to?(self))
      throw WrongJobseekersResumeSubmissionException
    end

    submission = NewSubmission.new(by_jobseeker: self, with_resume: with_resume)

    @service.apply(with_submission: submission, to_job: job)
  end
end

class Application
  def initialize(to_job: nil, with_submission: nil)
    @job = to_job
    @submission = with_submission
  end

  def submitted_by?(jobseeker)
    @submission.submitted_by?(jobseeker)
  end

  def as_reportable
    job_reportable = @job.as_reportable
    submission_reportable = @submission.as_reportable
    OpenStruct.new(job: job_reportable, submission: submission_reportable)
  end
end

class ApplicationList < List
end

class ApplicationService
  def initialize
    @applications = ApplicationList.new
  end

  def apply(with_submission: nil, to_job: nil)
    application = Application.new(to_job: to_job, with_submission: with_submission)
    save_application(application)
  end

  def applications_by(jobseeker)
    @applications.select do |application|
      application.submitted_by?(jobseeker)
    end
  end

  private

  def save_application(application)
    @applications = @applications.with(application)
  end
end

module JobApplier
  include Reports
  include Filterable

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

  when_filtering_by :jobs do |filter|
    filtered_jobs = filter.filter_jobs(@applied_to)
    filtered_jobs.size > 0
  end

  when_reporting :jobs do |reportable|
    @applied_to ||= JobList.new # TODO: Can I initialize this in just one place?

    @applied_to.each do |job|
      job.report_to(reportable)
    end
  end
end
