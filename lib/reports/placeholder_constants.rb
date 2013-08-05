require 'jobs'

class JobseekerApplicationsReportGenerator 
  def initialize(jobseeker)
    @jobseeker = jobseeker
  end

  def generate_from(list)
    filtered_list = list.select do |jobseeker|
      @jobseeker == jobseeker
    end
    return JobseekerApplicationsReport.new(filtered_list)
  end
end

class JobseekerApplicationsReport
  def initialize(list)
    @list = list
  end

  def to_string
    report = JobListReport.new(@list)
    report.to_string
  end
end
