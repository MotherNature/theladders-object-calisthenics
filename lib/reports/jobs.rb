require 'jobs'

module JobStringFormatter
  def job_properties_as_string(job_title: nil, recruiter_name: nil)
    "Job[Title: #{job_title}][Recruiter: #{recruiter_name}]"
  end
end

class JobListReport
  include JobStringFormatter

  def initialize(list)
    @list = list
    @job_titles = []
    @recruiter_names = []
  end

  def display_job_title(title)
    @job_titles.push(title)
  end

  def display_recruiter_name(name)
    @recruiter_names.push(name)
  end

  def to_string
    @list.each do |item|
      item.display_on(self)
    end

    job_count = @job_titles.size
    job_strings = (0...job_count).map do |index|
      job_properties_as_string(job_title: @job_titles[index], recruiter_name: @recruiter_names[index])
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

  def display_job_title(title)
    @title = title
  end

  def display_recruiter_name(name)
    @name = name
  end

  def to_string
    @job.display_on(self)

    job_properties_as_string(job_title: @title, recruiter_name: @name)
  end
end
