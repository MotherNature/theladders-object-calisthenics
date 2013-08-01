require 'people'
require 'reports'

class Recruiter < Person
  def display_on(displayable)
    if(displayable.respond_to?(:display_recruiter_name))
      displayable.display_recruiter_name(@name)
    end
  end
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
