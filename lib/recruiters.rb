require 'people'
require 'reports'

class Recruiter < Person
  def display_on(displayable)
    if(displayable.respond_to?(:display_recruiter_name))
      displayable.display_recruiter_name(@name.to_string)
    end
  end
end

class RecruiterList < List
  include ListOrderedByName
end

class RecruiterListReport < ListReport
  def initialize
    @names = []
  end

  def display_recruiter_name(name)
    @names.push(name)
  end

  def to_string
    alphabetical_names = @names.sort
    alphabetical_names.join("\n")
  end
end

class RecruiterListReportGenerator < ListReportGenerator
  def generate_from(list)
    report = RecruiterListReport.new

    list.each do |recruiter|
      recruiter.display_on(report)
    end

    report
  end
end
