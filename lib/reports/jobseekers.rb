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
    @jobseeker.report_to(self)
  end

  upon_receiving :jobseeker_name do |name|
    @name = name
  end

  def to_string
    jobseeker_properties_as_string(jobseeker_name: @name)
  end
end

class JobseekerListReport < Report
  def initialize(list)
    @list = list
    @sub_reports = @list.map do |jobseeker|
      JobseekerReport.new(jobseeker)
    end
  end

  def to_string
    formatted_strings = @sub_reports.map do |report|
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
    @sub_report = JobListReport.new(@list)
  end

  def to_string
    @sub_report.to_string
  end
end
