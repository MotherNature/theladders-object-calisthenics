class Job
  def initialize(title: nil, posted_by: nil, type: nil)
    @title = title
    @posted_by = posted_by
    @type = type
  end

  def display_on(displayable)
    if(displayable.respond_to?(:display_job_title))
      displayable.display_job_title(@title)
    end
    @posted_by.display_on(displayable)
  end
end

class JobList
  def initialize(jobs=[])
    @jobs = jobs
  end

  def each(&block)
    @jobs.each(&block)
  end

  def with(job)
    JobList.new([*@jobs, job])
  end

  def display_on(displayable)
    self.each do |job|
      job.display_on(displayable)
    end
  end
end
