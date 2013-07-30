class CompositeFilterer
  def initialize(filterers=[])
    @filterers = filterers
  end

  def jobseekers_in(submissionrecordlist)
    jobseekerlist = JobseekerList.new
    filtered_list = as_filtered(submissionrecordlist)
    filtered_list.each do |submissionrecord|
      submissionrecord.add_jobseeker_to_jobseekerlist(jobseekerlist)
    end
    jobseekerlist
  end

  def as_filtered(submissionrecordlist)
    filtered_list = submissionrecordlist
    @filterers.each do |filterer|
      filtered_list = filterer.as_filtered(filtered_list)
    end
    filtered_list
  end
end
