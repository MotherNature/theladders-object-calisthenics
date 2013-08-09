require 'utilities'
require 'jobs'

class Employer
  include Reports
  include RoleTaker

  when_reporting :employer_name do |reportable|
    @name
  end
  
  def initialize(name: nil)
    @name = name
  end
end

class EmployerJobList < JobList
  def self.filtered_from(joblist: nil, posted_by: nil)
    filtered_list = joblist.select do |job|
      job.posted_by?(posted_by)
    end
    EmployerJobList.new(filtered_list)
  end
end

class AppliedToEmployersJobsJobApplierList < JobseekerList
  def self.filtered_from(jobapplierlist: nil, employer: nil)
    filtered_list = jobapplierlist.select do |jobapplier|
      jobapplier.applied_to_jobs_posted_by?(employer)
    end
    AppliedToEmployersJobsJobApplierList.new(filtered_list)
  end
end
