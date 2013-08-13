require 'submissions'
require 'resumes'

class Jobseeker
  include RoleTaker
  include Reports

  def initialize(name: nil)
    @name = name
  end

  def draft_resume
    Resume.new(created_by: self)
  end

  when_reporting :jobseeker_name do |reportable|
    @name.report_name_to(reportable)
  end
end

class JobseekerList < List
end
