$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'labels'
require 'recruiters'

describe RecruiterList do
  before(:each) do
    @recruiter1 = Recruiter.new(name: Name.new("Alice Green"))
    @recruiter2 = Recruiter.new(name: Name.new("Betty Smith"))
    @recruiter3 = Recruiter.new(name: Name.new("Candice Yarn"))
  end

  describe "List Recruiters" do
    it "should list Recruiters, ordered by name" do
      recruiterlist = RecruiterList.new([@recruiter1, @recruiter2, @recruiter3])
      recruiterlist.to_array.should == [@recruiter1, @recruiter2, @recruiter3]
    end

    it "should list Recruiters, ordered by name, even when added out of order" do
      recruiterlist = RecruiterList.new([@recruiter3, @recruiter2, @recruiter1])
      recruiterlist.to_array.should == [@recruiter1, @recruiter2, @recruiter3]
    end
  end
end

