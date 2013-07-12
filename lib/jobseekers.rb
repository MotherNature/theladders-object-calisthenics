require 'people'
require 'utilities'
require 'reports'

class Jobseeker < Person
end

class JobseekerList < List
  include ListOrderedByName
end

class JobseekerListReport < ListReport
  include GeneratesReportsOfNames
end

class JobseekerListReportGenerator < ListReportGenerator
  def generate_from(list)
    JobseekerListReport.new(list)
  end
end
