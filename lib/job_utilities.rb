module JobListAppender
  def add_job_to_joblist(joblist)
    joblist.add(@job)
  end
end

module ApplicationListAppender
  def add_application_to_applicationlist(applicationlist)
    applicationlist.add(@application)
  end
end

class ApplicationError < RuntimeError
end

class InvalidApplicationError < ApplicationError
end

class IncompatibleApplicationError < ApplicationError
end
