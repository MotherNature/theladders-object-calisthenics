require 'ostruct'

require 'utilities'

class JobApplierRole < DelegateClass(Object)
  def initialize(delegate_to: nil, apply_to_service: nil)
    @delegatee = delegate_to
    @service = apply_to_service
    super(@delegatee)
  end

  def apply_to_job(job: nil, on_date: Date.new, with_resume: NoResume) # TODO: Change back to just #apply_to after refactoring.
    if(with_resume.exists? && ! with_resume.belongs_to?(delegatee))
      raise WrongJobseekersResumeSubmissionException
    end

    submission = NewSubmission.new(by_jobseeker: self, with_resume: with_resume)

    @service.apply(with_submission: submission, to_job: job, on_date: on_date)
  end

  private

  def delegatee
    @delegatee
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

  def posted_by?(poster)
    @job.posted_by?(poster)
  end

  def valid?
    @submission.valid_for?(@job)
  end

  def as_reportable
    job_reportable = @job.as_reportable
    submission_reportable = @submission.as_reportable
    OpenStruct.new(job: job_reportable, submission: submission_reportable)
  end
end

class DatedApplication < SimpleDelegator
  def initialize(application: nil, submitted_on: nil)
    super(application)
    @date = submitted_on
  end

  def submitted_on?(date)
    @date == date
  end
end

class ApplicationList < List
end

class ApplicationService
  def initialize
    @applications = ApplicationList.new
  end

  def apply(with_submission: nil, to_job: nil, on_date: nil)
    application = Application.new(to_job: to_job, with_submission: with_submission)
    datedapplication = DatedApplication.new(application: application, submitted_on: on_date)
    save_application(datedapplication)
    application
  end

  def all_applications
    @applications
  end

  def applications_by(jobseeker)
    @applications.select do |application|
      application.submitted_by?(jobseeker)
    end
  end

  def select_applications_filtered_by(filters)
    @applications.select_filtered_by(filters)
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

class ApplicationDate
  def initialize(year, month, day)
  end
end

class ApplicationsByDateFilter
  def initialize(date)
    @date = date
  end

  def allows?(application)
    application.submitted_on?(@date)
  end
end

class ApplicationsByEmployersJobsFilter
end
