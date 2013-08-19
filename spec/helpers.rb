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

  def basic_jobseeker(name: "Betsy J. Basic")
    jobseeker = Jobseeker.new(name: Name.new(name))
  end

  def saving_jobseeker(name: "Sally Saver", save_to_repo: JobRepo.new)
    jobseeker = basic_jobseeker(name: name)
    JobSaverRole.new(roletaker: jobseeker, save_to_repo: save_to_repo)
  end

  def applying_jobseeker(name: "Jane Jobseek", apply_to_service: ApplicationService.new)
    jobseeker = basic_jobseeker(name: name)
    JobApplierRole.new(roletaker: jobseeker, apply_to_service: apply_to_service)
  end
end
