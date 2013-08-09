require 'submissions'
require 'resumes'

class Jobseeker
  include RoleTaker
  include Reports

  when_reporting :jobseeker_name do |reportable|
    @name
  end

  def initialize(name: nil)
    @name = name
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

  def with(jobseeker)
    JobseekerList.new([*@jobseekers, jobseeker])
  end

  def report_to(reportable)
    each do |jobseeker|
      jobseeker.report_to(reportable)
    end
  end
end
