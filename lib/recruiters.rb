class Recruiter
  def initialize(name: nil)
    @name = name
  end

  def post_job(title: nil)
    Job.new(title: title, posted_by: self)
  end

  def display_on(displayable)
    if(displayable.respond_to?(:display_recruiter_name))
      displayable.display_recruiter_name(@name)
    end
  end
end

# TODO: move to lib/jobs.rb
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
