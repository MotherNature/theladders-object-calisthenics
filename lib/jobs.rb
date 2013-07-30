require 'utilities'
require 'job_utilities'
require 'posting_utilities'
require 'labels'
require 'reports'
require 'jobseekers'

class Job
  def initialize(title: nil, jobtype: nil)
    @title = title
    @jobtype = jobtype
  end

  def requires_resume?
    @jobtype.requires_resume?
  end

  def title_to_string
    @title.to_string
  end

  def jobtype_to_string
    @jobtype.to_string
  end
end

class JobFactory
  def initialize
    @jobtypefactory = JobTypeFactory.new
  end

  def build_job(title_string: nil, jobtype_string: nil)
    title = Title.new(title_string)
    jobtype = @jobtypefactory.build_jobtype(jobtype_string)
    Job.new(title: title, jobtype: jobtype)
  end
end

class JobList < List
  def posted_by(recruiter)
    select do |job|
      job.posted_by(recruiter)
    end
  end

  public
  # TODO: Replace exposed method with a more explicit verb.
  def add(job)
    super(job)
  end
end

class JobListReport < ListReport
  def to_string
    jobs = @list.to_array
    report_strings = jobs.map do |job|
      "Title: #{job.title_to_string}\nType: #{job.jobtype_to_string}"
    end
    report_strings.join("\n---\n")
  end
end

class JobListTitleReport < ListReport
  def to_string
    jobs = @list.to_array
    title_strings = jobs.map do |job|
      "Title: #{job.title_to_string}"
    end
    title_strings.join("\n")
  end
end

class JobApplicationSubmissionRecord
  def initialize(jobapplicationsubmission: nil, recorded_at_datetime: nil)
    @jobapplicationsubmission = jobapplicationsubmission
    @recorded_at_datetime = recorded_at_datetime
  end

  def recorded_at_datetime?(datetime)
    @recorded_at_datetime == datetime
  end

  def add_jobseeker_to_jobseekerlist(jobseekerlist)
    @jobapplicationsubmission.add_jobseeker_to_jobseekerlist(jobseekerlist)
  end

  def add_posting_to_postinglist(postinglist)
    @jobapplicationsubmission.add_posting_to_postinglist(postinglist)
  end

  def applied_to_by_jobseeker?(jobseeker)
    @jobapplicationsubmission.jobapplication_applied_to_by?(jobseeker)
  end

  def posting_posted_by_recruiter?(recruiter)
    @jobapplicationsubmission.posting_posted_by_recruiter?(recruiter)
  end
end

class JobApplicationSubmissionRecordList < List
  def jobapplicationsubmissionrecords_for_postings_by_recruiter(recruiter)
  end

  def jobseekers_applying_to_jobs_posted_by_recruiter(recruiter)
    jobseekerlist = JobseekerList.new

    filtered_jobapplicationsubmissionrecordlist = select do |jobapplicationsubmissionrecord|
      jobapplicationsubmissionrecord.posting_posted_by_recruiter?(recruiter)
    end

    filtered_jobapplicationsubmissionrecordlist.each do |jobapplicationsubmissionrecord|
      jobapplicationsubmissionrecord.add_jobseeker_to_jobseekerlist(jobseekerlist)
    end

    jobseekerlist
  end

  def postings_posted_by_recruiter(recruiter)
    postinglist = PostingList.new

    filteredrecords = select do |jobapplicationsubmissionrecord|
      jobapplicationsubmissionrecord.posting_posted_by_recruiter?(recruiter)
    end

    filteredrecords.each do |record|
      record.add_posting_to_postinglist(postinglist)
    end

    postinglist
  end

  def jobs_posted_by(recruiter)
    joblist = JobList.new

    filtered_postinglist = postings_posted_by_recruiter(recruiter) # Why do I keep running into empty lists or what looks like them?
    filtered_postinglist.each do |posting|
      posting.add_job_to_joblist(joblist)
    end

    joblist
  end
end
