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
    @titles = []
  end

  def display_job_title(title)
    @titles.push(title)
  end

  def to_string
    @list.each do |displayer|
      displayer.display_on(self)
    end
    @titles.join("\n")
  end
end
