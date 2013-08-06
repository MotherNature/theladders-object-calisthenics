class Resume
  def initialize(created_by: nil)
    @jobseeker = created_by
  end

  def exists?
    true
  end

  def belongs_to?(jobseeker)
    @jobseeker == jobseeker
  end
end

class NoResume
  def self.exists?
    false
  end
end
