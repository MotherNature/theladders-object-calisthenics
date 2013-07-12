require 'people'

class Recruiter < Person
end

class RecruiterList < List
  def to_array
    recruiters = super
    recruiters.sort_by do |recruiter|
      recruiter.name_to_string
    end
  end
end

