require 'people'
require 'utilities'
require 'reports'

class Jobseeker < Person
end

class JobseekerList < List
  include ListOrderedByName
end

class JobseekerListReport < ListReport
end

class JobseekerListReportGenerator < ListReportGenerator
end
