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

describe JobSaverRole do
  it "can save even if its role-taker has taken on additional roles" do
    expect do
      jobseeker = applying_jobseeker
      saving_jobseeker = JobSaverRole.new(roletaker: jobseeker, save_to_repo: JobRepo.new)
      job = posted_job

      saving_jobseeker.apply_to_job(job: job)
      saving_jobseeker.save_job(job)
    end.to_not raise_error
  end
end

describe JobApplierRole do
  it "can apply even if its role-taker has taken on additional roles" do
    expect do
      jobseeker = saving_jobseeker
      applying_jobseeker = JobApplierRole.new(roletaker: jobseeker, apply_to_service: ApplicationService.new)
      job = posted_job

      applying_jobseeker.save_job(job)
      applying_jobseeker.apply_to_job(job: job)
    end.to_not raise_error
  end
end
