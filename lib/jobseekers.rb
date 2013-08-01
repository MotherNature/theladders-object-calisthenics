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
  def initialize
    @names = []
  end

  def display_jobseeker_name(name)
    @names.push(name)
  end

  def to_string
    alphabetical_names = @names.sort
    alphabetical_names.join("\n")
  end
end

class JobseekerListReportGenerator < ListReportGenerator
  def generate_from(list)
    report = JobseekerListReport.new

    list.each do |jobseeker|
      jobseeker.display_on(report)
    end

    report
  end
end
