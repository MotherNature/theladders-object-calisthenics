class Jobseeker
  def initialize
    @jobs = []
  end

  def apply_to(job: nil)
    @jobs.push(job)
  end

  def display_on(displayable)
    @jobs.each do |job|
      job.display_on(displayable)
    end
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
