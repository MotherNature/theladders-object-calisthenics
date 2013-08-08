require 'utilities'
require 'jobs'

class Employer
  include Reports

  when_reporting :employer_name do
    @name
  end
  
  def initialize(name: nil)
    @name = name
  end

  def take_on_role(role_module)
    extend role_module
  end
end
