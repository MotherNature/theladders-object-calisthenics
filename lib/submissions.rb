class Submission
  def initialize(with_resume: nil, submitted_to: nil)
    @resume = with_resume
    @job = submitted_to
  end

  def valid?
    @job.suitable_resume?(@resume)
  end
end

class WrongJobseekersResumeSubmission < Submission
  def valid?
    false
  end
end

class SubmissionDate < Date
end

class NewSubmission
  def initialize(by_jobseeker: nil, with_resume: nil)
    @resume = with_resume
    @jobseeker = by_jobseeker
  end

  def submitted_by?(jobseeker)
    @jobseeker == jobseeker
  end

  def as_reportable
    resume_reportable = @resume.as_reportable
    jobseeker_reportable = @jobseeker.as_reportable
    OpenStruct.new(resume: resume_reportable, jobseeker: jobseeker_reportable)
  end
end

class WrongJobseekersResumeSubmissionException < Exception
end
