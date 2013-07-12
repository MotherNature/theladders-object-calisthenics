require 'people'
require 'reports'

class Recruiter < Person
end

class RecruiterList < List
  include ListOrderedByName
end

class RecruiterListReport < ListReport
end

class RecruiterListReportGenerator < ListReportGenerator
end
