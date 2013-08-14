require 'jobs'
require 'jobseekers'
require 'employers'
require 'reports/jobs'
require 'reports/jobseekers'

class EmployersPostedJobReportGenerator
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

class JobseekerAndJobsReport < Report
  include JobseekerStringFormatter
  include JobStringFormatter

  def initialize(jobseeker)
    prepare_subreports(jobseeker)
  end

  def to_string
    job_rows = @joblistreport.to_string

    jobseeker_row = @jobseekerreport.to_string

    [jobseeker_row, job_rows].join("\n")
  end

  private

  def prepare_subreports(jobseeker)
    jobseekerlist = JobseekerList.new([jobseeker])

    @joblistreport = JobListReport.new(jobseekerlist)

    @jobseekerreport = JobseekerReport.new(jobseeker)
  end
end

class JobseekersAndJobsListReport < Report
  def initialize(list)
    @sub_reports = list.map do |jobseeker|
      JobseekerAndJobsReport.new(jobseeker)
    end
  end

  def to_string
    reports = [ ]

    @sub_reports.each do |report|
      report_as_string = report.to_string
      reports.push(report_as_string)
    end

    reports.join("\n---\n")
  end
end
