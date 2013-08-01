class Application
  include JobListAppender

  def initialize(jobseeker: nil, resume: nil)
    if(! resume.nil? && ! resume.belongs_to?(jobseeker))
      raise InvalidApplicationError.new("The Resume does not belong to the Jobseeker")
    end

    @jobseeker = jobseeker
    @resume = resume
  end

  def display_on(displayable)
    @jobseeker.display_on(displayable)
    if(has_resume?)
      @resume.display_on(displayable)
    end
  end

  # TODO: rename to applied_to_by_jobseeker?
  def applied_to_by?(jobseeker)
    @jobseeker == jobseeker
  end

  def has_resume?
    ! @resume.nil?
  end

  def has_this_resume?(resume)
    @resume == resume
  end

  def add_jobseeker_to_jobseekerlist(jobseekerlist)
    jobseekerlist.add(@jobseeker)
  end
end

class ApplicationList < List
  def jobseeker_applies_to_job(jobseeker: nil, job: nil)
    application = Application.new(job: job, jobseeker: jobseeker)
    add(application)
  end

  def applications_submitted_by(jobseeker)
    select do |application|
      application.applied_to_by?(jobseeker)
    end
  end

  def jobs_applied_to_by(jobseeker)
    select do |application|
      application.add_job_to_joblist(joblist)
    end
  end

  public
  # TODO: Replace exposed method with a more explicit verb.
  def add(job)
    super(job)
  end
end

