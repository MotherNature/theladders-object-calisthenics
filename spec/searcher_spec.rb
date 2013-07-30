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
require 'searchers'

describe "Searchers" do
  before(:each) do
    @examplefactory = ExampleFactory.new

    @jobseeker = @examplefactory.build_jobseeker
    @recruiter = @examplefactory.build_recruiter

    @job = @examplefactory.build_job

    @jobapplicationlist = JobApplicationList.new
    @postinglist = PostingList.new
    @jobapplicationsubmissionrecordlist = SubmissionRecordList.new

    @jobapplicationsubmissionservice = SubmissionService.new

    jobapplicationpreparer = JobApplicationPreparer.new(jobseeker: @jobseeker, jobapplicationlist: @jobapplicationlist)

    @jobapplication = jobapplicationpreparer.prepare_application

    jobapplicationsubmitter = Submitter.new(jobapplication: @jobapplication, jobapplicationsubmissionservice: @jobapplicationsubmissionservice)

    jobapplicationsubmissionrecorder = SubmissionRecorder.new(jobapplicationsubmitter: jobapplicationsubmitter, jobapplicationsubmissionrecordlist: @jobapplicationsubmissionrecordlist)

    jobposter = JobPoster.new(recruiter: @recruiter, postinglist: @postinglist)

    @posting = jobposter.post_job(@job)

    jobapplicationsubmissionrecorder.submit_application(@posting)

    @toplist = @jobapplicationsubmissionrecordlist
  end

  describe JobSearcher do
    describe "#posted_by_recruiter" do
      describe "[PostingList]" do
        it "should return a JobList with the Job posted by a given Recruiter" do
          jobsearcher = JobSearcher.new(@postinglist)

          joblist = jobsearcher.posted_by_recruiter(@recruiter)

          joblist.should include(@job)
        end
      end

      describe "[SubmissionRecordList]" do
        it "should return a JobList with the Job posted by a given Recruiter" do
          jobsearcher = JobSearcher.new(@jobapplicationsubmissionrecordlist)

          joblist = jobsearcher.posted_by_recruiter(@recruiter)

          joblist.should include(@job)
        end
      end
    end
  end
end
