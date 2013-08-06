require 'submissions'
require 'resumes'

class JobApplier
  def initialize
    @applied_to = JobList.new
  end

  def apply_to(job: nil, with_resume: nil)
    submission = Submission.new(with_resume: with_resume, submitted_to: job)
    if(submission.valid?)
      @applied_to = @applied_to.with(job)
    end
    submission
  end

  def display_on(displayable)
    @applied_to.display_on(displayable)
  end
end

class Jobseeker
  def initialize
    @applier = JobApplier.new
  end

  def draft_resume
    Resume.new
  end

  def apply_to(job: nil, with_resume: nil)
    @applier.apply_to(job: job, with_resume: with_resume)
  end

  def display_on(displayable)
    @applier.display_on(displayable)
  end
end

class JobseekerList
  def initialize(jobseekers)
    @jobseekers = jobseekers
  end

  def size
    @jobseekers.size
  end

  def each(&block)
    @jobseekers.each(&block)
  end

  def select(&block)
    JobseekerList.new(@jobseekers.select(&block))
  end
end
