require 'jobseekers'

class HTMLJobseekerReport
  def initialize(reportable)
    @name = reportable.name
  end

  def render
    %{<div class="jobseeker"><span class="name">#{@name}</span></div>}
  end
end

class HTMLJobseekerListReport
  def initialize(jobseekers)
    @sub_reports = jobseekers.map do |jobseeker|
      reportable = jobseeker.as_reportable
      HTMLJobseekerReport.new(reportable)
    end
  end

  def render
    rendered_parts = @sub_reports.map do |report|
      report.render
    end
    rendered_parts.join
  end
end

class HTMLJobReport < ReportableJobReport
  def render
    %{<div class="job"><span class="title">#{@title}</span>#{employer_html}</div>}
  end

  private

  def employer_html
    if(@employer_name)
      %{<span class="employer"><span class="name">#{@employer_name}</span></span>}
    end
  end
end
