require 'jobs'

class EmployersPostedJobReportGenerator
  def initialize(employer)
  end

  def generate_from(list)
    filtered_list = list.select do |item|
      item.posted?
    end
      
    JobListReport.new(filtered_list)
  end
end
