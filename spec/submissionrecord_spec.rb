$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'labels'
require 'jobs'
require 'submissionrecords'
require 'jobseekers'
require 'recruiters'
require 'postings'
require 'resumes'
require 'examples'

describe SubmissionRecord do
  before(:each) do
    examplefactory = ExampleFactory.new

    @submissionservice = SubmissionService.new

    @jobseeker = examplefactory.build_jobseeker
    @recruiter = examplefactory.build_recruiter

    @job = examplefactory.build_job
    @posting = Posting.new(job: @job, posted_by: @recruiter)
    @application = Application.new(jobseeker: @jobseeker)

    @submissionservice.apply_application_to_posting(application: @application, posting: @posting)

    submissionlist = @submissionservice.submissions_submitted_for_application(@application)
    submissions = submissionlist.to_array
    @submission = submissions.first
  end

  describe "Record Time" do
    it "should record a given time for a Submission" do
      datetime = DateTime.new(2013, 7, 12, 0, 0, 0)
      submissionrecord = SubmissionRecord.new(submission: @submission, recorded_at_datetime: datetime)
      submissionrecord.recorded_at_datetime?(datetime).should be_true
    end
  end
end

describe SubmissionRecordList do
  before(:each) do
    examplefactory = ExampleFactory.new

    @submissionservice = SubmissionService.new

    @jobseeker1 = examplefactory.build_jobseeker
    @jobseeker2 = examplefactory.build_jobseeker

    @recruiter1 = examplefactory.build_recruiter
    @recruiter2 = examplefactory.build_recruiter

    @job1 = examplefactory.build_job
    @job2 = examplefactory.build_job
    @job3 = examplefactory.build_job

    @posting1 = Posting.new(job: @job1, posted_by: @recruiter1)
    @posting2 = Posting.new(job: @job2, posted_by: @recruiter1)
    @posting3 = Posting.new(job: @job3, posted_by: @recruiter2)

    @application1 = Application.new(jobseeker: @jobseeker1)
    @application2 = Application.new(jobseeker: @jobseeker1)
    @application3 = Application.new(jobseeker: @jobseeker2)

    @submission1 = @submissionservice.apply_application_to_posting(application: @application1, posting: @posting1)
    @submission2 = @submissionservice.apply_application_to_posting(application: @application2, posting: @posting2)
    @submission3 = @submissionservice.apply_application_to_posting(application: @application3, posting: @posting3)

    @datetime1 = DateTime.new(2013, 7, 12, 0, 0, 0)
    @datetime2 = DateTime.new(2013, 8, 13, 0, 0, 0)
    @datetime3 = DateTime.new(2013, 9, 14, 0, 0, 0)
    @datetime4 = DateTime.new(2013, 10, 15, 0, 0, 0)

    @submissionrecord1 = SubmissionRecord.new(submission: @submission1, recorded_at_datetime: @datetime1)
    @submissionrecord2 = SubmissionRecord.new(submission: @submission2, recorded_at_datetime: @datetime2)
    @submissionrecord3 = SubmissionRecord.new(submission: @submission2, recorded_at_datetime: @datetime3)
    @submissionrecord4 = SubmissionRecord.new(submission: @submission3, recorded_at_datetime: @datetime4)
  end

  describe "Find Jobseekers who applied to the Recruiter's Jobs" do
    it "should return a list of Jobseekers who have applied to Jobs posted by the Recruiter" do
      submissionrecordlist = SubmissionRecordList.new([@submissionrecord1, @submissionrecord2, @submissionrecord3, @submissionrecord4])
      jobseekerlist = submissionrecordlist.jobseekers_applying_to_jobs_posted_by_recruiter(@recruiter1)
      jobseekerlist.should include(@jobseeker1)
    end

    it "should return a list that does not include Jobseekers who have only applied to Jobs not posted by the Recruiter" do
      submissionrecordlist = SubmissionRecordList.new([@submissionrecord1, @submissionrecord2, @submissionrecord3, @submissionrecord4])
      jobseekerlist = submissionrecordlist.jobseekers_applying_to_jobs_posted_by_recruiter(@recruiter2)
      jobseekerlist.should_not include(@jobseeker1)
      jobseekerlist.should include(@jobseeker2)
    end

    it "should return a list with only one instance of each Jobseeker" do
      submissionrecordlist = SubmissionRecordList.new([@submissionrecord1, @submissionrecord2, @submissionrecord3, @submissionrecord4])
      jobseekerlist = submissionrecordlist.jobseekers_applying_to_jobs_posted_by_recruiter(@recruiter1)
      jobseekers = jobseekerlist.to_array
      jobseekers.size.should == 1
    end
  end
end

describe RecruiterSubmissionRecordFilter do
  before(:each) do
    examplefactory = ExampleFactory.new

    @submissionservice = SubmissionService.new

    @jobseeker1 = examplefactory.build_jobseeker
    @jobseeker2 = examplefactory.build_jobseeker

    @recruiter1 = examplefactory.build_recruiter
    @recruiter2 = examplefactory.build_recruiter

    @job1 = examplefactory.build_job
    @job2 = examplefactory.build_job
    @job3 = examplefactory.build_job

    @posting1 = Posting.new(job: @job1, posted_by: @recruiter1)
    @posting2 = Posting.new(job: @job2, posted_by: @recruiter1)
    @posting3 = Posting.new(job: @job3, posted_by: @recruiter2)

    @application1 = Application.new(jobseeker: @jobseeker1)
    @application2 = Application.new(jobseeker: @jobseeker1)
    @application3 = Application.new(jobseeker: @jobseeker2)

    @submission1 = @submissionservice.apply_application_to_posting(application: @application1, posting: @posting1)
    @submission2 = @submissionservice.apply_application_to_posting(application: @application2, posting: @posting2)
    @submission3 = @submissionservice.apply_application_to_posting(application: @application3, posting: @posting3)

    @datetime1 = DateTime.new(2013, 7, 12, 0, 0, 0)
    @datetime2 = DateTime.new(2013, 8, 13, 0, 0, 0)
    @datetime3 = DateTime.new(2013, 9, 14, 0, 0, 0)
    @datetime1_2 = DateTime.new(2013, 7, 12, 0, 0, 0)

    @submissionrecord1 = SubmissionRecord.new(submission: @submission1, recorded_at_datetime: @datetime1)
    @submissionrecord2 = SubmissionRecord.new(submission: @submission2, recorded_at_datetime: @datetime2)
    @submissionrecord3 = SubmissionRecord.new(submission: @submission2, recorded_at_datetime: @datetime3)
    @submissionrecord4 = SubmissionRecord.new(submission: @submission3, recorded_at_datetime: @datetime1_2)

    @submissionrecordlist = SubmissionRecordList.new([@submissionrecord1, @submissionrecord2, @submissionrecord3, @submissionrecord4])
  end

  describe "Find Jobseekers who applied to the Recruiter's Jobs" do
    it "should return a list of Jobseekers who have applied to Jobs posted by the Recruiter" do
      filter = RecruiterSubmissionRecordFilter.new(recruiter: @recruiter1, submissionrecordlist: @submissionrecordlist)
      jobseekerlist = filter.jobseekers
      jobseekerlist.should include(@jobseeker1)
    end
  end
end
