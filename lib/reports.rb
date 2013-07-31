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
  def generate_for_jobseeker_from_submissionlist(jobseeker: nil, submissionlist: nil)
    joblist = submissionlist.jobs_submitted_to_by_jobseeker(jobseeker)
    
    return JobsAppliedToReport.new(joblist)
  end
end

class JobseekersByDateReportGenerator < ListReportGenerator
  def initialize(date)
    @date = date
  end

  def generate_from(submissionrecordlist)
    jobseekerlist = JobseekerList.new
    submissionrecordlist.each do |submissionrecord|
      submissionrecord.add_jobseeker_to_jobseekerlist(jobseekerlist)
    end
    JobseekersByDateReport.new(jobseekerlist: jobseekerlist)
  end
end

class JobseekersByDateReport < ListReport
  def initialize(jobseekerlist: nil)
    @jobseekerlist = jobseekerlist
  end

  def to_string
    jobseekers = @jobseekerlist.to_array
    report_strings = jobseekers.map do |jobseeker|
      jobseeker.name_to_string
    end
    report_strings.join("\n")
  end
end
