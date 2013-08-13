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
    @jobseeker = jobseeker
  end

  def to_string
    jobseekerlist = JobseekerList.new([@jobseeker])

    joblistreport = JobListReport.new(jobseekerlist)

    job_rows = joblistreport.to_string

    jobseekerreport = JobseekerReport.new(@jobseeker)

    jobseeker_row = jobseekerreport.to_string

    [jobseeker_row, job_rows].join("\n")
  end
end

class JobseekersAndJobsListReport < Report
  def initialize(list)
    @list = list
  end

  def to_string
    reports = [ ]

    @list.each do |jobseeker|
      report = JobseekerAndJobsReport.new(jobseeker)
      report_as_string = report.to_string
      reports.push(report_as_string)
    end

    reports.join("\n---\n")
  end
end
