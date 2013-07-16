class ExampleFactory
  def initialize
    @jobseeker_name_strings = [
      "Alice Green",
      "Betty Smith",
      "Candice Yarn"
    ]
    @recruiter_name_strings = [
      "Rudy Allen",
      "Rachel Breecher",
      "Ralph Colbert"
    ]
  end

  def build_jobseeker
    Jobseeker.new(name: Name.new(@jobseeker_name_strings.shift))
  end

  def build_recruiter
    Recruiter.new(name: Name.new(@recruiter_name_strings.shift))
  end
end
