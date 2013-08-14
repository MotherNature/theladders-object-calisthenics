require 'jobseekers'

class TextUnpostedJobReport < UnpostedJobReport
  def render
    "Job[Title: #{job_title}]"
  end
end

class TextPostedJobReport < PostedJobReport
  def render
    "Job[Title: #{job_title}][Employer: #{poster_name}]"
  end
end

class TextJobListReport < JobListReport
end

class TextSavedJobListReport < SavedJobListReport
end
