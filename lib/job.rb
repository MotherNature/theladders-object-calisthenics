class Job
  def initialize(title: title, type: type, posted_by: posted_by)
    @title = title
    @type = type
    @posted_by = posted_by
  end

  def posted_by(recruiter)
    @posted_by == recruiter
  end

  def requires_resume?
    @type.requires_resume?
  end
end

class JobList
  def initialize(jobs=[])
    @jobs = jobs
  end

  def add(job)
    @jobs.push job
  end

  def post(job)
    add(job)
  end
  
  def include?(job)
    @jobs.include?(job)
  end

  def posted_by(recruiter)
    filtered_jobs = @jobs.select do |job|
      job.posted_by(recruiter)
    end

    JobList.new(filtered_jobs)
  end
end
