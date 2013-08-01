require 'csv'

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
  def initialize
    @jobtitles = []
    @jobtypes = []
  end

  def display_jobtitle(jobtitle)
    @jobtitles.push(jobtitle)
  end

  def display_jobtype(jobtype)
    @jobtypes.push(jobtype)
  end

  def to_string
    report_strings = []
    # TODO: Refactor to avoid assumption of equal-sized lists
    for i in 0...@jobtitles.size
      title = @jobtitles[i]
      type = @jobtypes[i]
      report_strings.push("Title: #{title}\nType: #{type}")
    end
    report_strings.join("\n---\n")
  end
end

class JobsAppliedToReportGenerator
  def generate_for_jobseeker_from_submissionlist(jobseeker: nil, submissionlist: nil)
    report = JobsAppliedToReport.new

    filtered_list = submissionlist.select do |submission|
      submission.application_applied_to_by?(jobseeker)
    end

    filtered_list.each do |submission|
      submission.display_on(report)
    end
    
    report
  end
end

class JobseekersByDateReportGenerator < ListReportGenerator
  def initialize(date)
    @date = date
  end

  def generate_from(submissionrecordlist)
    report = JobseekersByDateReport.new

    filtered_list = submissionrecordlist.select do |submissionrecord|
      submissionrecord.recorded_on_date?(@date)
    end

    filtered_list.each do |submissionrecord|
      submissionrecord.display_on(report)
    end

    report
  end
end

class JobseekersByDateReport
  def initialize
    @names = []
  end

  def display_jobseeker_name(name)
    @names.push(name)
  end

  def to_string
    alphabetical_names = @names.sort
    alphabetical_names.join("\n")
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
    report = ApplicationReport.new
    submissionrecordlist.each do |submissionrecord|
      submissionrecord.display_on(report)
    end
    report
  end
end

class ApplicationReport < ListReport
  def initialize
    @headers = ["Jobseeker", "Recruiter", "Job Title", "Date"]

    @jobseeker_names = []
    @recruiter_names = []
    @job_titles = []
    @dates = []
  end

  def display_jobseeker_name(name)
    @jobseeker_names.push(name)
  end

  def display_recruiter_name(name)
    @recruiter_names.push(name)
  end

  def display_jobtitle(title)
    @job_titles.push(title)
  end

  def display_date(date)
    @dates.push(date)
  end

  def to_string
    jobseeker_max_width = 0
    recruiter_max_width = 0
    job_max_width = 0
    date_max_width = 0

    rows = [ ]
    for i in 0...@jobseeker_names.size
      jobseeker_name = @jobseeker_names[i]
      if(jobseeker_name.size > jobseeker_max_width)
        jobseeker_max_width = jobseeker_name.size
      end

      recruiter_name = @recruiter_names[i]
      if(recruiter_name.size > recruiter_max_width)
        recruiter_max_width = recruiter_name.size
      end

      job_title = @job_titles[i]
      if(job_title.size > job_max_width)
        job_max_width = job_title.size
      end

      date = @dates[i]
      if(date.size > date_max_width)
        date_max_width = date.size
      end

      rows.push([jobseeker_name, recruiter_name, job_title, date])
    end

    format = "| %-#{jobseeker_max_width}s | %-#{recruiter_max_width}s | %-#{job_max_width}s | %-#{date_max_width}s |"

    header_and_rows = [@headers, *rows]

    report_strings = header_and_rows.map {|row| sprintf(format, *row) }
    report_strings.join("\n")
  end

  def to_csv
    rows = [@headers]
    for i in 0...@jobseeker_names.size
      jobseeker_name = @jobseeker_names[i]
      recruiter_name = @recruiter_names[i]
      job_title = @job_titles[i]
      date = @dates[i]
      row = [jobseeker_name, recruiter_name, job_title, date]
      rows.push(row)
    end
    row_strings = rows.map do |row|
      CSV.generate_line(row)
    end
    row_strings.join
  end
end
