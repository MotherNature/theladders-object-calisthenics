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

class JobseekersAndJobsListReport < Report
  include JobseekerStringFormatter
  include JobStringFormatter

  def initialize(list)
    @list = list
    @jobseeker_names = []
    @titles = []
    @employer_names = []
  end

  reports_on :jobs

  when_reporting :jobseeker_name do |name|
    @jobseeker_names.push(name)
  end

  when_reporting :employer_name do |name|
    @employer_names.push(name)
  end

  when_reporting :job_title do |name|
    @titles.push(name)
  end

  def to_string
    @list.report_to(self)

    entries = [ ]
    (0...@jobseeker_names.size).each do |index|
      rows = [ ]
      rows.push(jobseeker_properties_as_string(jobseeker_name: @jobseeker_names[index]))
      rows.push(job_properties_as_string(job_title: @titles[index], employer_name: @employer_names[index]))
      entry = rows.join("\n")
      entries.push(entry)
    end

    entries.join("\n---\n")
  end
end
