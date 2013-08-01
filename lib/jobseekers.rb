require 'people'
require 'utilities'
require 'reports'

class Jobseeker < Person
  def display_on(displayable)
    if(displayable.respond_to?(:display_jobseeker_name))
      @name.display_on(displayable)
    end
  end
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
