$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

require 'labels'
require 'job'
require 'jobseeker'

jobtypefactory = JobTypeFactory.new

describe Jobseeker do
  it "is pending" do
    pending "Placeholder."
  end
end
