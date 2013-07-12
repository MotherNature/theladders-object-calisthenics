require 'people'
require 'utilities'

class Jobseeker < Person
  def name_as_string
    @name.to_string
  end
end

class JobseekerList < List
  def as_array
    jobseekers = to_array
    jobseekers.sort_by do |jobseeker|
      jobseeker.name_as_string
    end
  end
end

class JobseekerListReport
  def initialize(jobseekerlist)
    @jobseekerlist = jobseekerlist
  end

  def to_string
    name_strings = @jobseekerlist.as_array.map do |jobseeker|
      jobseeker.name_as_string
    end
    name_strings.join("\n")
  end
end

class JobseekerListReportGenerator
  def generate_from(jobseekerlist)
    jobseekerlistreport = JobseekerListReport.new(jobseekerlist)
  end
end
