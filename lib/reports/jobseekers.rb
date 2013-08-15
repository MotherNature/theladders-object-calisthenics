require 'jobs'

module JobseekerStringFormatter
  def jobseeker_properties_as_string(jobseeker_name: nil)
    "Jobseeker[Name: #{jobseeker_name}]"
  end
end

class JobseekerReport < Report
  include JobseekerStringFormatter

  def initialize(jobseeker)
    @name = ""
    jobseeker.report_to(self)
  end

  upon_receiving :jobseeker_name do |name|
    @name = name
  end

  def to_string
    jobseeker_properties_as_string(jobseeker_name: jobseeker_name)
  end

  private

  def jobseeker_name
    @name
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
