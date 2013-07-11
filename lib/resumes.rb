class Resume
  def initialize(jobseeker: nil)
    @jobseeker = jobseeker
  end

  def belongs_to?(jobseeker)
    @jobseeker == jobseeker
  end
end
