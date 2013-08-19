$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'jobs'
require 'jobseekers'
require 'employers'
require 'resumes'
require 'applications'

require 'helpers'

RSpec.configure do |klass|
  klass.include Helpers
end

describe JobApplierRole do
  it "can apply even if its role-taker has taken on additional roles" do
    expect do
      jobseeker = applying_jobseeker
      saving_jobseeker = JobSaverRole.new(roletaker: jobseeker, save_to_repo: JobRepo.new)
      job = posted_job

      saving_jobseeker.apply_to_job(job: job)
      saving_jobseeker.save_job(job)
    end.to_not raise_error
  end
end
