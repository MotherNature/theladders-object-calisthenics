module Helpers
  def posting_employer(name: "Erin Employ")
    employer = Employer.new(name: name)
    employer.take_on_role(JobPoster)
    employer
  end

  def posted_job(title: "A Job", type: JobType.ATS, poster: posting_employer)
    unposted_job = UnpostedJob.new(title: title, type: type)

    job = poster.post_job(unposted_job)
  end

  def saving_jobseeker
    jobseeker = Jobseeker.new
    jobseeker = JobSaver.with_role_performed_by(@jobseeker)
  end
end
