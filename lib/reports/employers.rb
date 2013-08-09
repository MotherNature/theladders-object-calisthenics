require 'jobs'
require 'employers'

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
    JobseekerListReport.new(only_applied_to_employers_jobs_jobseekers)
  end
end
