class Job
  def initialize(title: title, type: type)
  end
end

class JobList
  def initialize()
    @jobs = []
  end

  def post(job)
    @jobs.push job
  end
  
  def include?(job)
    @jobs.include?(job)
  end
end
