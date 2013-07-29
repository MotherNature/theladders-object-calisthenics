require 'labels'

class JobSearcher
  def initialize(list)
    @list = list
  end

  def posted_by_recruiter(recruiter)
    @list.jobs_posted_by(recruiter)
  end
end
