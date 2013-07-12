require 'people'

class Recruiter < Person
  def name_to_string
    @name.to_string
  end
end

class RecruiterList < List
  def to_array
    recruiters = super
    recruiters.sort_by do |recruiter|
      recruiter.name_to_string
    end
  end
end

