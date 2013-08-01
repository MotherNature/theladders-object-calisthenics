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
  def initialize(job: nil, submission_count: nil)
    @job = job
    @submission_count = submission_count
  end

  def to_string
    "#{@job.title_to_string}: #{@submission_count}"
  end
end

class JobAggregateReportGenerator < AggregateReportGenerator 
  def initialize(job)
    @job = job
  end

  def generate_from(submissionrecordlist)
    filtered_list = submissionrecordlist.select do |submissionrecord|
      submissionrecord.for_job?(@job)
    end

    submissionrecords = filtered_list.to_array

    JobAggregateReport.new(job: @job, submission_count: submissionrecords.size)
  end
end

class RecruiterAggregateReportGenerator < AggregateReportGenerator 
  def initialize(recruiter)
    @recruiter = recruiter
  end

  def generate_from(submissionrecordlist)
    filtered_list = submissionrecordlist.select do |submissionrecord|
      submissionrecord.posting_posted_by_recruiter?(@recruiter)
    end

    submissionrecords = filtered_list.to_array

    RecruiterAggregateReport.new(recruiter: @recruiter, submission_count: submissionrecords.size)
  end
end

class RecruiterAggregateReport < ListReport
  def initialize(recruiter: nil, submission_count: nil)
    @recruiter = recruiter
    @submission_count = submission_count
  end

  def to_string
    "#{@recruiter.name_to_string}: #{@submission_count}"
  end
end

class ApplicationReportGenerator < ListReportGenerator 
  def generate_from(submissionrecordlist)
    ApplicationReport.new(submissionrecordlist)
  end
end

class ApplicationReport < ListReport
  def initialize(submissionrecordlist)
    @submissionrecordlist = submissionrecordlist
  end

  def to_string
    jobseeker_max_width = 0
    recruiter_max_width = 0
    job_max_width = 0
    date_max_width = 0

    headers = ["Jobseeker", "Recruiter", "Job Title", "Date"]
    rows = [ ]
    @submissionrecordlist.each do |submissionrecord|
      jobseeker_name = "Judy Jobseeker" # submissionrecord.jobseeker_name_to_string
      if(jobseeker_name.size > jobseeker_max_width)
        jobseeker_max_width = jobseeker_name.size
      end

      recruiter_name = "Rudy Recruiter" # submissionrecord.recruiter_name_to_string
      if(recruiter_name.size > recruiter_max_width)
        recruiter_max_width = recruiter_name.size
      end

      job_title = "Lion Tamer" # submissionrecord.job_title_to_string
      if(job_title.size > recruiter_max_width)
        job_max_width = job_title.size
      end

      date = "12/21/2013" # submissionrecord.date_to_string
      if(date.size > date_max_width)
        date_max_width = date.size
      end

      rows.push([jobseeker_name, recruiter_name, job_title, date])
    end

    format = "| %#{jobseeker_max_width}s | %#{recruiter_max_width}s | %#{job_max_width}s | %#{date_max_width}s |"

    rows.map {|row| sprintf(format, *row) }.join("\n")
  end
end
