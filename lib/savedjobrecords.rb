class SavedJobRecord
  include JobListAppender

  def initialize(job: nil, jobseeker: nil)
    @job = job
    @jobseeker = jobseeker
  end

  def saved_by?(jobseeker)
    @jobseeker == jobseeker
  end

  def job_title_to_string
    @job.title_to_string
  end
end

class JobListReportGenerator < ListReportGenerator
  def generate_from(joblist)
    JobListReport.new(joblist)
  end
  def generate_titles_from(joblist)
    JobListTitleReport.new(joblist)
  end
end

class SavedJobRecordList < List
  def save_job_for_jobseeker(job: nil, jobseeker: nil)
    savedjobrecord = SavedJobRecord.new(job: job, jobseeker: jobseeker)
    add(savedjobrecord)
  end

  def records_saved_by(jobseeker)
    select do |savedjobrecord|
      savedjobrecord.saved_by?(jobseeker)
    end
  end

  def jobs_saved_by(jobseeker)
    joblist = JobList.new

    records_saved_by(jobseeker).each do |savedjobrecord|
      savedjobrecord.add_job_to_joblist(joblist)
    end

    joblist
  end
end

class SavedJobListReport < ListReport
  def to_string
    jobs = @list.to_array
    title_strings = jobs.map do |job|
      "Title: #{job.title_to_string}"
    end
    title_strings.join("\n")
  end
end

class SavedJobListReportGenerator < ListReportGenerator
  def generate_from(savedjoblist)
    SavedJobListReport.new(savedjoblist)
  end
end

