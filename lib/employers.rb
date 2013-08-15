require 'utilities'
require 'jobs'

class Employer
  include Reports
  include TakesRoles
  
  def initialize(name: nil)
    @name = name
  end

  Reportable = Struct.new(:name)
  
  def as_reportable
    Reportable.new(@name.as_reportable)
  end

  when_reporting :employer_name do |reportable|
    @name.report_name_to(reportable)
  end
end
