require 'jobseekers'

class TextJobReport < JobReport
  def render
    job_string = "Job[Title: #{@title}]"
    employer_string = @employer_name ? "[Employer: #{@employer_name}]" : ""
    "#{job_string}#{employer_string}"
  end
end

class TextJobListReport < JobListReport
end

class TextJobseekerReport
  def initialize(reportable)
    @name = reportable.name
  end

  def render
    "Jobseeker[Name: #{name}]"
  end

  private
  def name
    @name
  end
end

class TextJobseekersSavedJobsReport
  def initialize(reportable)
    job_reportables = reportable.jobs
    @sub_reports = job_reportables.map do |job_reportable|
      TextJobReport.new(job_reportable)
    end
  end

  def render
    rendered = @sub_reports.map do |report|
      report.render
    end

    rendered.join("\n")
  end
end

class TextApplicationsJobsReport
  def initialize(list)
    @reports = list.map do |application|
      application_reportable = application.as_reportable
      job_reportable = application_reportable.job
      TextJobReport.new(job_reportable)
    end
  end
  
  def render
    rendered_reports = @reports.map do |report|
      report.render
    end
    rendered_reports.join("\n")
  end
end

class TextEmployersPostedJobReportGenerator
  def initialize(employer)
    @employer = employer
  end

  def generate_from(joblist)
    is_posted = PostedJobFilter.new
    posted_by = PostedByFilter.new(@employer)

    filtered_jobs = joblist.select_filtered_by([is_posted, posted_by])

    JobListReport.new(filtered_jobs)
  end
end

class TextApplicantsReport
  def initialize(applications)
    @subreports = applications.map do |application|
      application_reportable = application.as_reportable
      jobseeker_reportable = application_reportable.submission.jobseeker
      TextJobseekerReport.new(jobseeker_reportable)
    end
  end

  def render
    reports = @subreports.map do |report|
      report.render
    end
    reports.join("\n")
  end
end

class TextDateReport
  def initialize(reportable)
    @month = reportable.month
    @day = reportable.day
    @year = reportable.year
  end
  
  def render
    "Date[Month: #{@month}][Day: #{@day}][Year: #{@year}]"
  end
end

class TextApplicationReport
  def initialize(reportable)
    @jobseeker_report = TextJobseekerReport.new(reportable.submission.jobseeker)
    @job_report = TextJobReport.new(reportable.job)
    @date_report = TextDateReport.new(reportable.date)
  end

  def render
    rendered_reports = [@jobseeker_report, @job_report, @date_report].map do |report|
      report.render
    end
    rendered_reports.join("\n")
  end
end

class ApplicationCountReport
  def initialize(list)
    @list = list
  end

  def render
    @list.size.to_s
  end
end
