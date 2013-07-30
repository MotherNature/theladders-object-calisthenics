module JobListAppender
  def add_job_to_joblist(joblist)
    joblist.add(@job)
  end
end

module ApplicationListAppender
  def add_jobapplication_to_jobapplicationlist(jobapplicationlist)
    jobapplicationlist.add(@jobapplication)
  end
end

class ApplicationError < RuntimeError
end

class InvalidApplicationError < ApplicationError
end

class IncompatibleApplicationError < ApplicationError
end
