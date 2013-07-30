class CompositeFilterer
  def initialize(filterers=[])
    @filterers = filterers
  end

  def jobseekers_in(submissionrecordlist)
    jobseekerlist = JobseekerList.new
    submissionrecordlist.each do |submissionrecord|
      submissionrecord.add_jobseeker_to_jobseekerlist(jobseekerlist)
    end
    jobseekerlist
  end

  def filtered(submissionrecordlist)
    submissionrecordlist
  end
end
