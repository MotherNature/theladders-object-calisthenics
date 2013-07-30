require 'utilities'
require 'job_utilities'
require 'posting_utilities'
require 'labels'
require 'reports'
require 'jobseekers'

class Job
  def initialize(title: nil, jobtype: nil)
    @title = title
    @jobtype = jobtype
  end

  def requires_resume?
    @jobtype.requires_resume?
  end

  def title_to_string
    @title.to_string
  end

  def jobtype_to_string
    @jobtype.to_string
  end
end

class JobFactory
  def initialize
    @jobtypefactory = JobTypeFactory.new
  end

  def build_job(title_string: nil, jobtype_string: nil)
    title = Title.new(title_string)
    jobtype = @jobtypefactory.build_jobtype(jobtype_string)
    Job.new(title: title, jobtype: jobtype)
  end
end

class JobList < List
  def posted_by(recruiter)
    select do |job|
      job.posted_by(recruiter)
    end
  end

  public
  # TODO: Replace exposed method with a more explicit verb.
  def add(job)
    super(job)
  end
end

class JobListReport < ListReport
  def to_string
    jobs = @list.to_array
    report_strings = jobs.map do |job|
      "Title: #{job.title_to_string}\nType: #{job.jobtype_to_string}"
    end
    report_strings.join("\n---\n")
  end
end

class JobListTitleReport < ListReport
  def to_string
    jobs = @list.to_array
    title_strings = jobs.map do |job|
      "Title: #{job.title_to_string}"
    end
    title_strings.join("\n")
  end
end

