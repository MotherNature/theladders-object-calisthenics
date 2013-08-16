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

class TextJobseekerApplicationsReport
  def initialize(list)
    @list = list
    @sub_report = JobListReport.new(@list)
  end

  def render
    @sub_report.render
  end
end

class TextJobseekerApplicationsReportGenerator < JobseekerApplicationsReportGenerator
  def initialize(jobseeker)
    super(jobseeker, report_class: TextJobseekerApplicationsReport)
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

    filtered_jobs = joblist.filtered_by([is_posted, posted_by])

    JobListReport.new(filtered_jobs)
  end
end

class ApplicantsReport
end
