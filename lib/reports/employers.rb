require 'jobs'

class EmployersPostedJobReportGenerator
  def initialize(employer)
    @employer = employer
  end

  def generate_from(joblist)
    posted_jobs = PostedJobList.filtered_from(joblist)

    employers_jobs = posted_jobs.select do |job|
      job.posted_by?(@employer)
    end
      
    JobListReport.new(employers_jobs)
  end
end
