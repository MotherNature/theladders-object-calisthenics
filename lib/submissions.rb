class Submission
  def initialize(with_resume: nil, submitted_to: nil)
    @resume = with_resume
    @job = submitted_to
  end

  def valid?
    @job.suitable_resume?(@resume)
  end
end

class SubmissionList
  def initialize(submissions=[])
    @submissions = submissions
  end

  def each(&block)
    @submissions.each(&block)
  end

  def select(&block)
    filtered_submissions = @submissions.select(&block)
    submissionList.new(filtered_submissions)
  end

  def any?(&block)
    filtered_list = select(&block)
    filtered_list.size > 0
  end

  def size
    @submissions.size
  end

  def with(submission)
    submissionList.new([*@submissions, submission])
  end

  def report_to(reportable)
    self.each do |submission|
      submission.report_to(reportable)
    end
  end
end

class WrongJobseekersResumeSubmission < Submission
  def valid?
    false
  end
end

class SubmissionDate < Date
end
