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

    filtered_list = submissionrecordlist.select do |submissionrecord|
      submissionrecord.recorded_on_date?(@date)
    end

    filtered_list.each do |submissionrecord|
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

class AggregateReportGenerator < ListReportGenerator
end

class JobAggregateReport < ListReport
  def initialize(joblist: nil)
    @joblist = joblist
  end

  def to_string
    jobs = @joblist.to_array
    report_strings = jobs.map do |job|
      "#{job.title_to_string}: 1"
    end
    report_strings.join("\n")
  end
end

class JobAggregateReportGenerator < AggregateReportGenerator 
  def initialize(job)
    @job = job
  end

  def generate_from(submissionrecordlist)
    joblist = JobList.new

    filtered_list = submissionrecordlist.select do |submissionrecord|
      submissionrecord.for_job?(@job)
    end

    filtered_list.each do |submissionrecord|
      submissionrecord.add_job_to_joblist(joblist)
    end

    JobAggregateReport.new(joblist: joblist)
  end
end

class RecruiterAggregateReportGenerator < AggregateReportGenerator 
end
