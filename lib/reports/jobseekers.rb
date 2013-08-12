require 'jobs'

module JobseekerStringFormatter
  def jobseeker_properties_as_string(jobseeker_name: nil)
    "Jobseeker[Name: #{jobseeker_name}]"
  end
end

class JobseekerReport < Report
  include JobseekerStringFormatter

  def initialize(jobseeker)
    @jobseeker = jobseeker
    @name = ""
  end

  when_reporting :jobseeker_name do |name|
    @name = name
  end

  def to_string
    @jobseeker.report_to(self)
    jobseeker_properties_as_string(jobseeker_name: @name)
  end
end

class JobseekerListReport < Report
  def initialize(list)
    @list = list
  end

  def to_string
    formatted_strings = @list.map do |jobseeker|
      report = JobseekerReport.new(jobseeker)
      report.to_string
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
