require 'people'

class Recruiter < Person
end

class RecruiterList < List
  include ListOrderedByName
end

