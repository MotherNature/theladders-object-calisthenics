class Recruiter
  def initialize(name: name)
    @name = name
  end

  def postJobToList(job: job, joblist: joblist)
    joblist.post(job)
  end
end
