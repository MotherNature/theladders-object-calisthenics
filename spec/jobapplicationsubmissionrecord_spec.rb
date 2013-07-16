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
      jobapplicationsubmissionrecord = JobApplicationSubmissionRecord.new(jobapplicationsubmission: @jobapplicationsubmission, recorded_at_datetime: datetime)
      jobapplicationsubmissionrecord.recorded_at_datetime?(datetime).should be_true
    end
  end
end

describe JobApplicationSubmissionRecordList do
  before(:each) do
    @jobfactory = JobFactory.new
    @jobapplicationsubmissionservice = JobApplicationSubmissionService.new

    @jobseeker1 = Jobseeker.new(name: Name.new("Jane Doe"))
    @jobseeker2 = Jobseeker.new(name: Name.new("Sally Lane"))

    @recruiter1 = Recruiter.new(name: Name.new("Rudy Smith"))
    @recruiter2 = Recruiter.new(name: Name.new("Larry Nowel"))

    @job1 = @jobfactory.build_job(title_string: "Example Title", jobtype_string: "ATS")
    @job2 = @jobfactory.build_job(title_string: "Other Example Title", jobtype_string: "ATS")
    @job3 = @jobfactory.build_job(title_string: "Another Example Title", jobtype_string: "ATS")

    @posting1 = Posting.new(job: @job1, posted_by: @recruiter1)
    @posting2 = Posting.new(job: @job2, posted_by: @recruiter1)
    @posting3 = Posting.new(job: @job3, posted_by: @recruiter2)

    @jobapplication1 = JobApplication.new(jobseeker: @jobseeker1)
    @jobapplication2 = JobApplication.new(jobseeker: @jobseeker1)
    @jobapplication3 = JobApplication.new(jobseeker: @jobseeker2)

    @jobapplicationsubmissionservice.apply_jobapplication_to_posting(jobapplication: @jobapplication1, posting: @posting1)
    @jobapplicationsubmissionservice.apply_jobapplication_to_posting(jobapplication: @jobapplication2, posting: @posting2)
    @jobapplicationsubmissionservice.apply_jobapplication_to_posting(jobapplication: @jobapplication3, posting: @posting3)

    @jobapplicationsubmission1 = @jobapplicationsubmissionservice.jobapplicationsubmissions_submitted_for_jobapplication(@jobapplication1).to_array.first
    @jobapplicationsubmission2 = @jobapplicationsubmissionservice.jobapplicationsubmissions_submitted_for_jobapplication(@jobapplication2).to_array.first
    @jobapplicationsubmission3 = @jobapplicationsubmissionservice.jobapplicationsubmissions_submitted_for_jobapplication(@jobapplication3).to_array.first

    @datetime1 = DateTime.new(2013, 7, 12, 0, 0, 0)
    @datetime2 = DateTime.new(2013, 8, 13, 0, 0, 0)
    @datetime3 = DateTime.new(2013, 9, 14, 0, 0, 0)
    @datetime4 = DateTime.new(2013, 10, 15, 0, 0, 0)

    @jobapplicationsubmissionrecord1 = JobApplicationSubmissionRecord.new(jobapplicationsubmission: @jobapplicationsubmission1, recorded_at_datetime: @datetime1)
    @jobapplicationsubmissionrecord2 = JobApplicationSubmissionRecord.new(jobapplicationsubmission: @jobapplicationsubmission2, recorded_at_datetime: @datetime2)
    @jobapplicationsubmissionrecord3 = JobApplicationSubmissionRecord.new(jobapplicationsubmission: @jobapplicationsubmission2, recorded_at_datetime: @datetime3)
    @jobapplicationsubmissionrecord4 = JobApplicationSubmissionRecord.new(jobapplicationsubmission: @jobapplicationsubmission3, recorded_at_datetime: @datetime4)
  end

  describe "Find Jobseekers who applied to the Recruiter's Jobs" do
    it "should return a list of Jobseekers who have applied to Jobs posted by the Recruiter" do
      jobapplicationsubmissionrecordlist = JobApplicationSubmissionRecordList.new([@jobapplicationsubmissionrecord1, @jobapplicationsubmissionrecord2, @jobapplicationsubmissionrecord3, @jobapplicationsubmissionrecord4])
      jobseekerlist = jobapplicationsubmissionrecordlist.jobseekers_applying_to_jobs_posted_by_recruiter(@recruiter1)
      jobseekerlist.should include(@jobseeker1)
    end

    it "should return a list that does not include Jobseekers who have only applied to Jobs not posted by the Recruiter" do
      jobapplicationsubmissionrecordlist = JobApplicationSubmissionRecordList.new([@jobapplicationsubmissionrecord1, @jobapplicationsubmissionrecord2, @jobapplicationsubmissionrecord3, @jobapplicationsubmissionrecord4])
      jobseekerlist = jobapplicationsubmissionrecordlist.jobseekers_applying_to_jobs_posted_by_recruiter(@recruiter2)
      jobseekerlist.should_not include(@jobseeker1)
      jobseekerlist.should include(@jobseeker2)
    end

    it "should return a list with only one instance of each Jobseeker" do
      jobapplicationsubmissionrecordlist = JobApplicationSubmissionRecordList.new([@jobapplicationsubmissionrecord1, @jobapplicationsubmissionrecord2, @jobapplicationsubmissionrecord3, @jobapplicationsubmissionrecord4])
      jobseekerlist = jobapplicationsubmissionrecordlist.jobseekers_applying_to_jobs_posted_by_recruiter(@recruiter1)
      jobseekers = jobseekerlist.to_array
      jobseekers.size.should == 1
    end
  end
end
