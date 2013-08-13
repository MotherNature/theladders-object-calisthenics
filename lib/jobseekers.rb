require 'submissions'
require 'resumes'

class Jobseeker
  include RoleTaker
  include Reports

  def initialize(name: nil)
    @name = name
  end

  def draft_resume
    Resume.new(created_by: self)
  end

  when_reporting :jobseeker_name do |reportable|
    @name.report_name_to(reportable)
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

  def include?(jobseeker)
    @jobseekers.include?(jobseeker)
  end

  def filtered_by(filters)
    filtered_jobseekers = @jobseekers.select do |jobseeker|
      filters.all? do |filter|
        jobseeker.passes_filter?(filter)
      end
    end
    JobseekerList.new(filtered_jobseekers)
  end

  def report_to(reportable)
    each do |jobseeker|
      jobseeker.report_to(reportable)
    end
  end
end
