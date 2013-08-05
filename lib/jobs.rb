class Job
  def initialize(title: nil)
    @title = title
  end

  def display_on(displayable)
    if(displayable.respond_to?(:display_job_title))
      displayable.display_job_title(@title)
    end
  end
end
