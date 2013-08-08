require 'jobs'

class EmployersPostedJobReportGenerator
  def initialize(employer)
    @employer = employer
  end

  def generate_from(list)
    filtered_list = list.select do |item|
      item.posted? && item.posted_by?(@employer)
    end
      
    JobListReport.new(filtered_list)
  end
end
