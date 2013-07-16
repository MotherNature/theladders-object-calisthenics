class ExampleJobseekerFactory
  def initialize
    @name_strings = [
      "Alice Green",
      "Betty Smith",
      "Candice Yarn"
    ]
  end

  def build
    Jobseeker.new(name: Name.new(@name_strings.shift))
  end
end
