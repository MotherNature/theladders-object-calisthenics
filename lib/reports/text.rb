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

class TextSavedJobListReport < SavedJobListReport
end

class TextJobseekerApplicationsReport
  def initialize(list)
    @list = list
    @sub_report = JobListReport.new(@list)
  end

  def to_string
    @sub_report.to_string
  end
end

class TextJobseekerApplicationsReportGenerator < JobseekerApplicationsReportGenerator
  def initialize(jobseeker)
    super(jobseeker, report_class: TextJobseekerApplicationsReport)
  end
end
