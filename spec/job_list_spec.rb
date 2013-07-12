$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'labels'
require 'jobs'

describe JobList do
  before(:each) do
    jobfactory = JobFactory.new

    @job1 = jobfactory.build_job(title_string: "Applied Technologist", jobtype_string: "ATS")
    @job2 = jobfactory.build_job(title_string: "Bench Warmer", jobtype_string: "ATS")
    @job3 = jobfactory.build_job(title_string: "Candy Tester", jobtype_string: "ATS")
  end

  describe "List Jobs" do
    it "should list all of the added jobs" do
      joblist = JobList.new([@job1, @job2, @job3])
      joblist.to_array.should include @job1
      joblist.to_array.should include @job2
      joblist.to_array.should include @job3
    end
  end
end

