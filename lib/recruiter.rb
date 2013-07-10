require 'job_utilities'

class Recruiter
  include JobListAppender

  def initialize(name: name)
    @name = name
  end
end
