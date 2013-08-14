require 'jobseekers'

class TextUnpostedJobReport < UnpostedJobReport
  def report
    "Job[Title: #{job_title}]"
  end
end

class TextPostedJobReport < PostedJobReport
  def report
    "Job[Title: #{job_title}][Employer: #{poster_name}]"
  end
end
