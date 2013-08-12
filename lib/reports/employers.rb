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
    @jobseeker_name = ""
  end

  reports_on :jobs

  when_reporting :jobseeker_name do |name|
    @jobseeker_name = name
  end

  def to_string
    @jobseeker.report_to(self)

    jobseekerlist = JobseekerList.new([@jobseeker])

    joblistreport = JobListReport.new(jobseekerlist)

    jobs = joblistreport.to_string

    job_row = jobseeker_properties_as_string(jobseeker_name: @jobseeker_name)

    [job_row, jobs].join("\n")
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
