require 'jobs'

module JobStringFormatter
  def job_properties_as_string(job_title: nil, employer_name: nil)
    "Job[Title: #{job_title}][Employer: #{employer_name}]"
  end
end

class JobListReport < Report
  include JobStringFormatter

  def initialize(list)
    @job_titles = []
    @employer_names = []

    prepare_report(list)
  end

  reports_on :jobs

  upon_receiving :job_title do |title|
    @job_titles.push(title)
  end

  upon_receiving :employer_name do |name|
    @employer_names.push(name)
  end

  def to_string
    job_count = @job_titles.size
    job_strings = (0...job_count).map do |index|
      job_properties_as_string(job_title: @job_titles[index], employer_name: @employer_names[index])
    end
    job_strings.join("\n")
  end

  private

  def prepare_report(list)
    list.each do |item|
      item.report_to(self)
    end
  end
end

class JobReport < Report
  include JobStringFormatter

  def initialize(job)
    @title = nil
    @name = nil

    job.report_to(self)
  end

  upon_receiving :job_title do |title|
    @title = title
  end

  upon_receiving :employer_name do |name|
    @name = name
  end

  def to_string
    job_properties_as_string(job_title: job_title, employer_name: employer_name)
  end

  private

  def job_title
    @title
  end

  def employer_name
    poster_name
  end

  def poster_name
    @name
  end
end

class UnpostedJobReport < JobReport
end

class PostedJobReport < SimpleDelegator
  include HumanReadableDelegation

  def initialize(job)
    @unpostedjobreport = UnpostedJobReport.new(job)
    super(@unpostedjobreport)
  end
end

class SavedJobListReport < JobListReport
  reports_on :saved_jobs
end
