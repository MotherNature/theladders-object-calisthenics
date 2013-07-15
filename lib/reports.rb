module GeneratesReportsOfNames
  def to_string
    name_strings = @list.to_array.map do |list_item|
      list_item.name_to_string
    end
    name_strings.join("\n")
  end
end

class ListReport
  def initialize(list)
    @list = list
  end

  def to_string
    ""
  end
end

class ListReportGenerator
  def generate_from(list)
    ListReport.new(list)
  end
end

class JobsAppliedToReport
  def initialize(joblist=nil)
    @joblist = joblist
  end

  def to_string
    joblistreport = JobListReport.new(@joblist)
    joblistreport.to_string
  end
end

class JobsAppliedToReportGenerator
  def generate_for_jobseeker_from_jobapplicationrecordlist(jobseeker: nil, jobapplicationrecordlist: nil)
    joblist = jobapplicationrecordlist.jobs_submitted_to_by_jobseeker(jobseeker)
    
    return JobsAppliedToReport.new(joblist)
  end
end
