$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'labels'
require 'recruiters'

describe RecruiterListReportGenerator do
  before(:each) do
    idnumberservice = IDNumberService.new

    @recruiter1 = Recruiter.new(name: Name.new("Alice Green"), idnumber: idnumberservice.generate_idnumber)
    @recruiter2 = Recruiter.new(name: Name.new("Betty Smith"), idnumber: idnumberservice.generate_idnumber)
    @recruiter3 = Recruiter.new(name: Name.new("Candice Yarn"), idnumber: idnumberservice.generate_idnumber)

    @recruiterlistreportgenerator = RecruiterListReportGenerator.new
  end

  describe "Generate Recruiter Report" do
    it "should list Recruiters, ordered by name" do
      recruiterlist = RecruiterList.new([@recruiter1, @recruiter2, @recruiter3])
      recruiterlistreport = @recruiterlistreportgenerator.generate_from(recruiterlist)
      recruiterlistreport.to_string.should == "Alice Green\nBetty Smith\nCandice Yarn"
    end

    it "should list Recruiters, ordered by name, even when added out of order" do
      recruiterlist = RecruiterList.new([@recruiter3, @recruiter2, @recruiter1])
      recruiterlistreport = @recruiterlistreportgenerator.generate_from(recruiterlist)
      recruiterlistreport.to_string.should == "Alice Green\nBetty Smith\nCandice Yarn"
    end
  end
end
