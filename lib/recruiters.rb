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
