require 'submissions'
require 'resumes'

class Jobseeker
  include RoleTaker

  def initialize
  end

  def draft_resume
    Resume.new(created_by: self)
  end
end

class JobseekerList
  def initialize(jobseekers)
    @jobseekers = jobseekers
  end

  def size
    @jobseekers.size
  end

  def each(&block)
    @jobseekers.each(&block)
  end

  def select(&block)
    JobseekerList.new(@jobseekers.select(&block))
  end
end
