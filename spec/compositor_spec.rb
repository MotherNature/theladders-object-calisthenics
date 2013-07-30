$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'labels'
require 'jobs'
require 'jobseekers'
require 'recruiters'
require 'postings'
require 'resumes'
require 'examples'
require 'compositors'

describe "Compositors" do
  before(:each) do
    @examplefactory = ExampleFactory.new

    @jobseeker = @examplefactory.build_jobseeker
    @recruiter = @examplefactory.build_recruiter

    @job = @examplefactory.build_job

    @jobapplicationlist = ApplicationList.new
    @postinglist = PostingList.new
    @submissionrecordlist = SubmissionRecordList.new

    @submissionservice = SubmissionService.new
  end

  describe JobPoster do
    describe "#post_job" do
      it "should return a Posting" do
        jobposter = JobPoster.new(recruiter: @recruiter, postinglist: @postinglist)

        posting = jobposter.post_job(@job)

        [posting.class, *posting.class.ancestors].should include(Posting)
      end
    end
  end

  describe ApplicationPreparer do
    describe "#prepare_application" do
      it "should return a Application" do
        jobapplicationpreparer = ApplicationPreparer.new(jobseeker: @jobseeker, jobapplicationlist: @jobapplicationlist)

        jobapplication = jobapplicationpreparer.prepare_application

        [jobapplication.class, *jobapplication.class.ancestors].should include(Application)
      end
    end
  end

  describe Submitter do
    before(:each) do
      jobapplicationpreparer = ApplicationPreparer.new(jobseeker: @jobseeker, jobapplicationlist: @jobapplicationlist)

      @jobapplication = jobapplicationpreparer.prepare_application

      jobposter = JobPoster.new(recruiter: @recruiter, postinglist: @postinglist)

      @posting = jobposter.post_job(@job)
    end

    describe "#submit_application" do
      it "should return a Submission" do
        submitter = Submitter.new(jobapplication: @jobapplication, submissionservice: @submissionservice)


        submission = submitter.submit_application(@posting)

        [submission.class, *submission.class.ancestors].should include(Submission)
      end
    end
  end

  describe SubmissionRecorder do
    before(:each) do
      jobapplicationpreparer = ApplicationPreparer.new(jobseeker: @jobseeker, jobapplicationlist: @jobapplicationlist)

      @jobapplication = jobapplicationpreparer.prepare_application

      jobposter = JobPoster.new(recruiter: @recruiter, postinglist: @postinglist)

      @posting = jobposter.post_job(@job)

      @submitter = Submitter.new(jobapplication: @jobapplication, submissionservice: @submissionservice)
    end

    describe "#submit_application" do
      it "should return a SubmissionRecord" do
        submissionrecorder = SubmissionRecorder.new(submitter: @submitter, submissionrecordlist: @submissionrecordlist)


        submissionrecord = submissionrecorder.submit_application(@posting)

        [submissionrecord.class, *submissionrecord.class.ancestors].should include(SubmissionRecord)
      end
    end
  end

  describe "Full Run" do
    it "should compose in a complete chain without an error" do
      jobapplicationpreparer = ApplicationPreparer.new(jobseeker: @jobseeker, jobapplicationlist: @jobapplicationlist)

      jobapplication = jobapplicationpreparer.prepare_application

      submitter = Submitter.new(jobapplication: jobapplication, submissionservice: @submissionservice)

      submissionrecorder = SubmissionRecorder.new(submitter: submitter, submissionrecordlist: @submissionrecordlist)

      jobposter = JobPoster.new(recruiter: @recruiter, postinglist: @postinglist)

      posting = jobposter.post_job(@job)

      submissionrecorder.submit_application(posting)
    end
  end
end
