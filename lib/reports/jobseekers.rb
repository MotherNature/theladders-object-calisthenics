require 'jobs'

module JobseekerStringFormatter
  def jobseeker_properties_as_string(jobseeker_name: nil)
    "Jobseeker[Name: #{jobseeker_name}]"
  end
end

class JobseekerListReport
  include JobseekerStringFormatter

  def initialize(list)
    @list = list
    @names = []
  end

  def report_jobseeker_name(name)
    @names.push(name)
  end

  def to_string
    @list.report(self)

    formatted_strings = @names.map do |name|
      jobseeker_properties_as_string(jobseeker_name: name)
    end

    formatted_strings.join("\n")
  end
end

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
