module JobListAppender
  def add_job_to_joblist(joblist)
    joblist.add(@job)
  end
end

module JobApplicationListAppender
  def add_jobapplication_to_jobapplicationlist(jobapplicationlist)
    jobapplicationlist.add(@jobapplication)
  end
end

class JobApplicationError < RuntimeError
end

class InvalidJobApplicationError < JobApplicationError
  def to_s
    "Invalid JobApplication"
  end
end

class IncompatibleJobApplicationError < JobApplicationError
  def to_s
    "Incompatible JobApplication"
  end
end
