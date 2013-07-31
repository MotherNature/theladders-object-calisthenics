$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

describe JobseekersByDateReportGenerator do
  before(:each) do
    jobfactory = JobFactory.new
    idnumberservice = IDNumberService.new

    @examplefactory = ExampleFactory.new

    submissionservice = SubmissionService.new

    job = @examplefactory.build_job

    recruiter = @examplefactory.build_recruiter

    @posting = Posting.new(job: job, posted_by: recruiter)

    @jobseeker1 = @examplefactory.build_jobseeker
    @jobseeker2 = @examplefactory.build_jobseeker
    @jobseeker3 = @examplefactory.build_jobseeker

    applicationlist = ApplicationList.new
    postinglist = PostingList.new
    
    jobposter = JobPoster.new(recruiter: recruiter, postinglist: postinglist)
    jobposter.post_job(job)

    applicationpreparer1 = ApplicationPreparer.new(jobseeker: @jobseeker1, applicationlist: applicationlist)
    applicationpreparer2 = ApplicationPreparer.new(jobseeker: @jobseeker2, applicationlist: applicationlist)
    applicationpreparer3 = ApplicationPreparer.new(jobseeker: @jobseeker3, applicationlist: applicationlist)

    submitter1 = Submitter.new(application: applicationpreparer1.prepare_application, submissionservice: submissionservice)
    submitter2 = Submitter.new(application: applicationpreparer2.prepare_application, submissionservice: submissionservice)
    submitter3 = Submitter.new(application: applicationpreparer3.prepare_application, submissionservice: submissionservice)

    @submissionrecordlist = SubmissionRecordList.new

    @submissionrecorder1 = SubmissionRecorder.new(submitter: submitter1, submissionrecordlist: @submissionrecordlist)
    @submissionrecorder2 = SubmissionRecorder.new(submitter: submitter2, submissionrecordlist: @submissionrecordlist)
    @submissionrecorder3 = SubmissionRecorder.new(submitter: submitter3, submissionrecordlist: @submissionrecordlist)

    @reportgenerator = JobseekersByDateReportGenerator.new
  end

  describe "Generate Jobseeker Report" do
    it "should list all Jobseekers by default" do
      @submissionrecorder1.submit_application(@posting)
      @submissionrecorder2.submit_application(@posting)
      @submissionrecorder3.submit_application(@posting)

      report = @reportgenerator.generate_from(@submissionrecordlist)
      report.to_string.should == "Alice Green\nBetty Smith\nCandice Yarn"
    end
  end
end
