class Submission
  def initialize(with_resume: nil, submitted_to: nil)
    @resume = with_resume
    @job = submitted_to
  end

  def valid?
    @job.suitable_resume?(@resume)
  end
end
