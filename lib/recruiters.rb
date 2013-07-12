require 'people'

class Recruiter < Person
end

class RecruiterList < List
  include ListOrderedByName
end

class RecruiterListReport
  def initialize(recruiterlist)
    @recruiterlist = recruiterlist
  end

  def to_string
    name_strings = @recruiterlist.to_array.map do |recruiter|
      recruiter.name_to_string
    end
    name_strings.join("\n")
  end
end

class RecruiterListReportGenerator
  def generate_from(recruiterlist)
    recruiterlistreport = RecruiterListReport.new(recruiterlist)
  end
end
