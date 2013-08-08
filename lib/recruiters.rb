require 'jobs'

class Recruiter
  def initialize(name: nil)
    @name = name
  end

  def display_on(displayable)
    if(displayable.respond_to?(:display_recruiter_name))
      displayable.display_recruiter_name(@name)
    end
  end
end

class JobPoster < SimpleDelegator
  alias_method :redirectee, :__getobj__

  def post_job(job)
    PostedJob.new(job: job, posted_by: redirectee)
  end

  def self.assign_role_to(redirectee)
    self.new(redirectee)
  end
end
