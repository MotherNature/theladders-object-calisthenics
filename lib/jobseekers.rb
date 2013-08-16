require 'utilities'
require 'submissions'
require 'resumes'
require 'reports'

class Jobseeker
  include TakesRoles
  include Reports

  def initialize(name: nil)
    @name = name
  end

  def draft_resume
    Resume.new(created_by: self)
  end

  Reportable = Struct.new(:name)

  def as_reportable
    Reportable.new(@name.as_reportable)
  end

  when_reporting :jobseeker_name do |reportable|
    @name.report_name_to(reportable)
  end
end

class JobseekerList < List
end
