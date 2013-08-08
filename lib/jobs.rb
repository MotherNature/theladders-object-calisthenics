class JobType
  class ATS
    def suitable_resume?(resume)
      ! resume.exists?
    end
  end

  class JReq
    def suitable_resume?(resume)
      resume.exists?
    end
  end

  def self.ATS
    ATS.new
  end

  def self.JReq
    JReq.new
  end
end

class UnpostedJob
  def initialize(title: nil, type: nil)
    @title = title
    @type = type
  end

  def display_on(displayable)
    if(displayable.respond_to?(:display_job_title))
      displayable.display_job_title(@title)
    end
    #@posted_by.display_on(displayable)
  end

  def suitable_resume?(resume)
    @type.suitable_resume?(resume)
  end
end

class PostedJob < SimpleDelegator
  alias_method :redirectee, :__getobj__

  def initialize(job: nil, posted_by: nil)
    super(job)
    @poster = posted_by
  end

  def display_on(displayable)
    redirectee.display_on(displayable)
    @poster.display_on(displayable)
  end
end

class JobList
  def initialize(jobs=[])
    @jobs = jobs
  end

  def each(&block)
    @jobs.each(&block)
  end

  def with(job)
    JobList.new([*@jobs, job])
  end

  def display_on(displayable)
    self.each do |job|
      job.display_on(displayable)
    end
  end
end

class JobPoster < SimpleDelegator
  alias_method :redirectee, :__getobj__

  def post_job(job)
    PostedJob.new(job: job, posted_by: redirectee)
  end

  def self.assign_role_to(redirectee)
    self.new(redirectee)
  end

  def self.with_role_performed_by(redirectee)
    self.assign_role_to(redirectee)
  end
end

class JobSaver < SimpleDelegator
  alias_method :redirectee, :__getobj__

  def initialize(role_filler)
    super(role_filler)
  end

  def save_job(job)
  end

  def self.assign_role_to(redirectee)
    self.new(redirectee)
  end

  def self.with_role_performed_by(redirectee)
    self.assign_role_to(redirectee)
  end
end
