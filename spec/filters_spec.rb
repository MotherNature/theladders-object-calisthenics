$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'jobseekers'
require 'submissionrecords'
require 'filters'
require 'examples'

describe "Combine Filterers" do
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
    @submissionrecord5 = SubmissionRecord.new(submission: @submission3, recorded_at_datetime: @datetime1)

    @submissionrecordlist = SubmissionRecordList.new([@submissionrecord1, @submissionrecord2, @submissionrecord3, @submissionrecord4])
  end

  describe "Find just Jobseekers who applied to Jobs posted by a given Recruiter on a given Date" do
    it "should return a list of Jobseekers who have applied to Jobs on the given Date" do
      date = @datetime1.to_date

      datefilterer = DateSubmissionRecordFilterer.new(date)
      recruiterfilterer = RecruiterSubmissionRecordFilterer.new(@recruiter1)

      filterer = CompositeFilterer.new([datefilterer, recruiterfilterer])

      jobseekerlist = filterer.jobseekers_in(@submissionrecordlist)

      jobseekerlist.should include(@jobseeker1)
    end

    it "should return a list of only Jobseekers who have applied to Jobs on the given Date" do
      pending
      date = @datetime1.to_date

      datefilterer = DateSubmissionRecordFilterer.new(date)
      recruiterfilterer = RecruiterSubmissionRecordFilterer.new(@recruiter1)

      filterer = CompositeFilterer.new([datefilterer, recruiterfilterer])

      jobseekerlist = filterer.jobseekers_in(@submissionrecordlist)

      jobseekerlist.should_not include(@jobseeker2)
    end
  end
end
