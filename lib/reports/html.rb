require 'jobseekers'

class HTMLJobseekerReport < JobseekerReport
  def render
    %{<div class="jobseeker"><span class="name">#{jobseeker_name}</span></div>}
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

class HTMLJobReport < JobReport
  def render
    %{<div class="job"><span class="title">#{@title}</span></div>}
  end
end
