require 'jobs'
require 'jobseekers'
require 'employers'
require 'reports/jobs'
require 'reports/jobseekers'

class JobseekerAndJobsReport < Report
  include JobseekerStringFormatter
  include JobStringFormatter

  def initialize(jobseeker)
    prepare_subreports(jobseeker)
  end

  def render
    job_rows = @joblistreport.render

    jobseeker_row = @jobseekerreport.render

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

  def render
    reports = [ ]

    @sub_reports.each do |report|
      report_as_string = report.render
      reports.push(report_as_string)
    end

    reports.join("\n---\n")
  end
end
