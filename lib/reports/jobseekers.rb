require 'jobs'

class JobseekerApplicationsReportGenerator 
  def initialize(jobseeker, report_class: nil)
    @jobseeker = jobseeker
    @report_class = report_class
  end

  def generate_from(list)
    filtered_list = list.select do |jobseeker|
      @jobseeker == jobseeker
    end
    return @report_class.new(filtered_list)
  end
end
