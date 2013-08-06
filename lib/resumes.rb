class Resume
  def exists?
    true
  end
end

class NoResume
  def self.exists?
    false
  end
end
