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
