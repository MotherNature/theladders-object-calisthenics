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
    @job_title_strings = [
      "Applied Technologist",
      "Bench Warmer",
      "Candy Tester"
    ]
    @jobtype_strings = [
      "ATS",
      "ATS",
      "ATS"
    ]

    @jobfactory = JobFactory.new
  end

  def build_jobseeker
    Jobseeker.new(name: Name.new(@jobseeker_name_strings.shift))
  end

  def build_recruiter
    Recruiter.new(name: Name.new(@recruiter_name_strings.shift))
  end

  def build_job
    @jobfactory.build_job(title_string: @job_title_strings.shift, jobtype_string: @jobtype_strings.shift)
  end

  def build_resume_for_jobseeker(jobseeker)
    Resume.new(jobseeker: jobseeker)
  end
end
