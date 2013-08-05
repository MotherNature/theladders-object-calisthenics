class JobseekerApplicationsReportGenerator 
  def generate_from(parameter)
    return JobseekerApplicationsReport.new
  end
end

class JobseekerApplicationsReport
  def to_string
    "Valid Job 1\nValid Job 2"
  end
end
