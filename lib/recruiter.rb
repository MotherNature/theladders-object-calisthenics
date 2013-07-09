class Recruiter
  def initialize(name: name)
    @name = name
  end

  def post_job_to_list(job: job, joblist: joblist)
    joblist.post(job)
  end
end
