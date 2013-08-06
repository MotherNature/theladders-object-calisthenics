class Submission
  def initialize(with_resume: nil)
    @resume = with_resume
  end

  def valid?
    ! @resume.exists?
  end
end
