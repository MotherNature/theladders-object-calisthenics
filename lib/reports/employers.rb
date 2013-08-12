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
    only_posted_jobs = PostedJobList.filtered_from(joblist)
    only_employers_jobs = EmployerJobList.filtered_from(joblist: only_posted_jobs, posted_by: @employer)

    JobListReport.new(only_employers_jobs)
  end
end

class EmployersApplyingJobseekersByJobReportGenerator
  def initialize(employer)
    @employer = employer
  end

  def generate_from(jobseekerlist)
    only_applied_to_employers_jobs_jobseekers = AppliedToEmployersJobsJobApplierList.filtered_from(jobapplierlist: jobseekerlist, employer: @employer)
    JobseekersAndJobsListReport.new(only_applied_to_employers_jobs_jobseekers)
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
