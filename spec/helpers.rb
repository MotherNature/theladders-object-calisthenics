module Helpers
  def posting_employer(name: "Erin Employ")
    employer = Employer.new(name: Name.new(name))
    employer.take_on_role(JobPoster)
    employer
  end

  def unposted_job(title: "A Job", type: JobType.ATS, poster: posting_employer)
    UnpostedJob.new(title: Title.new(title), type: type)
  end

  def posted_job(title: "A Job", type: JobType.ATS, poster: posting_employer)
    unposted_job = UnpostedJob.new(title: Title.new(title), type: type)

    job = poster.post_job(unposted_job)
  end

  def saving_jobseeker
    jobseeker = Jobseeker.new
    jobseeker = JobSaver.with_role_performed_by(@jobseeker)
  end

  def applying_jobseeker(name: "Jane Jobseek")
    jobseeker = Jobseeker.new(name: Name.new(name))
    jobseeker.take_on_role(JobApplier)
  end
end
