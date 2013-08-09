require 'jobs'

module JobStringFormatter
  def job_properties_as_string(job_title: nil, employer_name: nil)
    "Job[Title: #{job_title}][Employer: #{employer_name}]"
  end
end

class JobListReport
  include JobStringFormatter

  def initialize(list)
    @list = list
    @job_titles = []
    @employer_names = []
  end

  def report_jobs(jobs)
  end

  def report_job_title(title)
    @job_titles.push(title)
  end

  def report_employer_name(name)
    @employer_names.push(name)
  end

  def to_string
    @list.each do |item|
      item.report(self)
    end

    job_count = @job_titles.size
    job_strings = (0...job_count).map do |index|
      job_properties_as_string(job_title: @job_titles[index], employer_name: @employer_names[index])
    end
    job_strings.join("\n")
  end
end

class JobReport
  include JobStringFormatter

  def initialize(job)
    @job = job
    @title = nil
    @name = nil
  end

  def report_job_title(title)
    @title = title
  end

  def report_employer_name(name)
    @name = name
  end

  def to_string
    @job.report(self)

    job_properties_as_string(job_title: @title, employer_name: @name)
  end
end

class SavedJobListReport < JobListReport
  def report_saved_job
  end
end
