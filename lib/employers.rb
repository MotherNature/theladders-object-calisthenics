require 'utilities'
require 'jobs'

class Employer
  include Reports
  include RoleTaker

  when_reporting :employer_name do
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
