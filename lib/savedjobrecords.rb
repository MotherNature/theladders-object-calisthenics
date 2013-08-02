class SavedJobRecord
  include JobListAppender

  def initialize(job: nil, jobseeker: nil)
    @job = job
    @jobseeker = jobseeker
  end

  def saved_by?(jobseeker)
    @jobseeker == jobseeker
  end
end

class JobListReportGenerator
  def generate_from(joblist)
    JobListReport.new(joblist)
  end
  def generate_titles_from(joblist)
    report = JobListTitleReport.new
    joblist.each do |job|
      job.display_on(report)
    end
    report
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
  def initialize
    @titles = []
  end

  def display_jobtitle(title)
    @titles.push(title)
  end

  def to_string
    title_strings = @titles.map do |title|
      "Title: #{title}"
    end
    title_strings.join("\n")
  end
end

class SavedJobListReportGenerator
  def generate_from(savedjoblist)
    report = SavedJobListReport.new
    savedjoblist.each do |job|
      job.display_on(report)
    end
    report
  end
end

