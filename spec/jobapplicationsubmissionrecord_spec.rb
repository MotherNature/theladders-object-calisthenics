$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'labels'
require 'jobs'
require 'jobseekers'
require 'recruiters'
require 'postings'
require 'resumes'

describe JobApplicationSubmissionRecord do
  before(:each) do
    @jobfactory = JobFactory.new
    @jobapplicationsubmissionservice = JobApplicationSubmissionService.new

    @jobseeker = Jobseeker.new(name: Name.new("Jane Doe"))
    @recruiter = Recruiter.new(name: Name.new("Rudy Smith"))

    @job = @jobfactory.build_job(title_string: "Example Title", jobtype_string: "ATS")
    @posting = Posting.new(job: @job, posted_by: @recruiter)
    @jobapplication = JobApplication.new(jobseeker: @jobseeker)

    @jobapplicationsubmissionservice.apply_jobapplication_to_posting(jobapplication: @jobapplication, posting: @posting)

    jobapplicationsubmissionlist = @jobapplicationsubmissionservice.jobapplicationsubmissions_submitted_for_jobapplication(@jobapplication)
    jobapplicationsubmissions = jobapplicationsubmissionlist.to_array
    @jobapplicationsubmission = jobapplicationsubmissions.first
  end

  describe "Record Time" do
    it "should record a given time for a JobApplicationSubmission" do
      datetime = DateTime.new(2013, 7, 12, 0, 0, 0)
      jobapplicationsubmissionrecord = JobApplicationSubmissionRecord.new(jobapplication: @jobapplication, recorded_at_datetime: datetime)
      jobapplicationsubmissionrecord.recorded_at_datetime?(datetime).should be_true
    end
  end
end
