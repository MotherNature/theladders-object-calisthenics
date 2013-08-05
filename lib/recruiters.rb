class Recruiter
  def initialize(name: nil)
  end

  def post_job(title: nil)
  end
end

class JobReport
  def initialize(job)
  end

  def to_string
    "Job[Title: Example Job][Recruiter: Robert Recruit]"
  end
end
