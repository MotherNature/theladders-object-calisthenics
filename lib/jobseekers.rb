class Jobseeker
  def initialize
    @joblist = JobList.new
  end

  def apply_to(job: nil)
    @joblist = @joblist.with(job)
  end

  def display_on(displayable)
    @joblist.display_on(displayable)
  end
end

class JobseekerList
  def initialize(jobseekers)
    @jobseekers = jobseekers
  end

  def size
    @jobseekers.size
  end

  def each(&block)
    @jobseekers.each(&block)
  end

  def select(&block)
    JobseekerList.new(@jobseekers.select(&block))
  end
end
