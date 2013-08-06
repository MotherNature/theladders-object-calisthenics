require 'submissions'
require 'resumes'

class Jobseeker
  def initialize
    @applied_to = JobList.new
  end

  def apply_to(job: nil, resume: nil)
    @applied_to = @applied_to.with(job)
    Submission.new(with_resume: resume, submitted_to: job)
    #Submission.new(submitted_by: self, submitted_to: job, with_resume: resume)
  end

  def draft_resume
    Resume.new
  end

  def display_on(displayable)
    @applied_to.display_on(displayable)
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
