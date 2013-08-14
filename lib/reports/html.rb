require 'jobseekers'

class HTMLJobseekerReport < Report
  def initialize(jobseeker)
    @name = ""
    jobseeker.report_to(self)
  end

  upon_receiving :jobseeker_name do |name|
    @name = name
  end

  def render
    %{<div class="jobseeker"><span class="name">#{@name}</span></div>}
  end
end

class HTMLJobseekerListReport
  def initialize(jobseekers)
    @sub_reports = jobseekers.map do |jobseeker|
      HTMLJobseekerReport.new(jobseeker)
    end
  end

  def render
    rendered_parts = @sub_reports.map do |report|
      report.render
    end
    rendered_parts.join
  end
end
