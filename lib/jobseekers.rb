require 'people'
require 'utilities'

class Jobseeker < Person
end

class JobseekerList < List
  include ListOrderedByName
end

class JobseekerListReport
  def initialize(jobseekerlist)
    @jobseekerlist = jobseekerlist
  end

  def to_string
    name_strings = @jobseekerlist.to_array.map do |jobseeker|
      jobseeker.name_to_string
    end
    name_strings.join("\n")
  end
end

class JobseekerListReportGenerator
  def generate_from(jobseekerlist)
    jobseekerlistreport = JobseekerListReport.new(jobseekerlist)
  end
end
