require 'people'
require 'reports'

class Recruiter < Person
end

class RecruiterList < List
  include ListOrderedByName
end

class RecruiterListReport < ListReport
  include GeneratesReportsOfNames
end

class RecruiterListReportGenerator < ListReportGenerator
  def generate_from(list)
    RecruiterListReport.new(list)
  end
end
