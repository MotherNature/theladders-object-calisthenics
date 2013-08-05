class Job
  def initialize(title: nil, posted_by: nil)
    @title = title
    @posted_by = posted_by
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

class JobListReport
  def initialize(list)
    @list = list
    @job_titles = []
    @recruiter_names = []
  end

  def display_job_title(title)
    @job_titles.push(title)
  end

  def display_recruiter_name(name)
    @recruiter_names.push(name)
  end

  def to_string
    @list.each do |item|
      item.display_on(self)
    end

    job_count = @job_titles.size
    job_strings = (0...job_count).map do |index|
      "Job[Title: #{@job_titles[index]}][Recruiter: #{@recruiter_names[index]}]"
    end
    job_strings.join("\n")
  end
end

class JobReport
  def initialize(job)
    @job = job
    @title = nil
    @recruiter = nil
  end

  def display_job_title(title)
    @title = title
  end

  def display_recruiter_name(name)
    @name = name
  end

  def to_string
    @job.display_on(self)
    "Job[Title: #{@title}][Recruiter: #{@name}]"
  end
end
