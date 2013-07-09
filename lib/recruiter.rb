class Recruiter
  def initialize(name: name)
    @name = name
  end

  def post_job_to_list(job: nil, joblist: nil)
    joblist.post(job)
  end
end
