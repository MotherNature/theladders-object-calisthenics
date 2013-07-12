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
