require 'jobs'

class Employer
  def initialize(name: nil)
    @name = name
  end

  def display_on(displayable)
    if(displayable.respond_to?(:display_employer_name))
      displayable.display_employer_name(@name)
    end
  end
end
