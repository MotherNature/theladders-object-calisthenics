require 'jobseekers'

class TextPostedJobReport < PostedJobReport
  def report
    "Job[Title: #{job_title}][Employer: #{poster_name}]"
  end
end
