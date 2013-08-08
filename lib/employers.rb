require 'utilities'
require 'jobs'

class Employer
  include Reports

  reports :employer_name do
    @name
  end
  
  def initialize(name: nil)
    @name = name
  end
end
