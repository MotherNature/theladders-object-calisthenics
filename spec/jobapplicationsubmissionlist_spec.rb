$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'labels'
require 'jobs'
require 'jobapplications'
require 'jobapplicationsubmissions'
require 'examples'

describe SubmissionList do
  before(:each) do

    examplefactory = ExampleFactory.new
    
    jobseeker = examplefactory.build_jobseeker
    recruiter = examplefactory.build_recruiter
    job = examplefactory.build_job

    @posting = Posting.new(job: job, posted_by: recruiter)
    @jobapplication = JobApplication.new(jobseeker: jobseeker)

    @jobapplicationsubmissionlist = SubmissionList.new
  end

  # TODO: Ask whether this implicit return is a bad idea and, if so, for alternative approaches.
  describe "#apply_jobapplication_to_posting" do
    it "should return the Submission created to record the posting activity" do
      jobapplicationsubmission = @jobapplicationsubmissionlist.apply_jobapplication_to_posting(jobapplication: @jobapplication, posting: @posting)
      jobapplicationsubmission.submitted_for_jobapplication?(@jobapplication).should be_true
      jobapplicationsubmission.submitted_for_posting?(@posting).should be_true
    end
  end
end

