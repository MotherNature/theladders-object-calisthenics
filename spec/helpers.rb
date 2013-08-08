module Helpers
  def posting_employer
    employer = Employer.new(name: "Erin Employ")
    employer.take_on_role(JobPoster)
    employer
  end

  def posted_job(title: "A Job")
    unposted_job = UnpostedJob.new(title: title, type: JobType.ATS)

    job = posting_employer.post_job(unposted_job)
  end

  def saving_jobseeker
    jobseeker = Jobseeker.new
    jobseeker = JobSaver.with_role_performed_by(@jobseeker)
  end
end
