$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib', 'reports'))

Dir[File.join(File.dirname(__FILE__), '..', 'lib', 'reports', '*.rb')].each do |report_lib|
  require report_lib
end

describe JobseekersByDateReportGenerator do
  before(:each) do
  end

  describe "Generate Jobseeker Report" do
    it "should list Jobseekers who applied on a given date" do
      pending "Restarting project"
      checked_date = Date.new(2012, 12, 21)
      not_checked_date = Date.new(2010, 9, 5)

      @submissionrecorder1.submit_application(posting: @posting, date: checked_date)
      @submissionrecorder2.submit_application(posting: @posting, date: not_checked_date)
      @submissionrecorder3.submit_application(posting: @posting, date: checked_date)

      reportgenerator = JobseekersByDateReportGenerator.new(checked_date)

      report = reportgenerator.generate_from(@submissionrecordlist)

      report.to_string.should == "Alice Green\nCandice Yarn"
    end
  end
end

describe AggregateReportGenerator do
  before(:each) do
  end

  describe "Generate Job Aggregate Application Report" do
    it "should show the number of times that Jobseekers applied to only the given Job" do
      pending "Restarting project"
      reportgenerator = JobAggregateReportGenerator.new(@job1)

      report = reportgenerator.generate_from(@submissionrecordlist)

      report.to_string.should == "Applied Technologist: 1"
    end

    it "should show the number of times that Jobseekers applied to only the given Job after multiple submissions" do
      pending "Restarting project"
      @repost.call
      @repost.call
      
      reportgenerator = JobAggregateReportGenerator.new(@job1)

      report = reportgenerator.generate_from(@submissionrecordlist)

      report.to_string.should == "Applied Technologist: 3"
    end
  end

  describe "Generate Recruiter Aggregate Application Report" do
    it "should show the number of times that Jobseekers applied to Jobs posted by the given Recruiter" do
      pending "Restarting project"
      reportgenerator = RecruiterAggregateReportGenerator.new(@recruiter1)

      report = reportgenerator.generate_from(@submissionrecordlist)

      report.to_string.should == "Rudy Allen: 1"
    end

    it "should show the number of times that Jobseekers applied to Jobs posted by the given Recruiter after multiple submissions" do
      pending "Restarting project"
      @repost.call
      @repost.call
      
      reportgenerator = RecruiterAggregateReportGenerator.new(@recruiter1)

      report = reportgenerator.generate_from(@submissionrecordlist)

      report.to_string.should == "Rudy Allen: 3"
    end
  end

  describe "Generate Overall Application Report" do
    it "should show just the headers when given an empty SubmissionRecordList" do
      pending "Restarting project"
      reportgenerator = ApplicationReportGenerator.new

      report = reportgenerator.generate_from(SubmissionRecordList.new)

      report.to_string.should == "| Jobseeker | Recruiter | Job Title | Date |"
    end

    it "should, for each SubmissionRecord, show the Jobseeker's name, Job title, Recruiter name, and submission Date" do
      pending "Restarting project"
      reportgenerator = ApplicationReportGenerator.new

      report = reportgenerator.generate_from(@submissionrecordlist)

      report.to_string.should ==
        "| Jobseeker    | Recruiter       | Job Title            | Date       |\n" +
        "| Alice Green  | Rudy Allen      | Applied Technologist | 12/21/2012 |\n" +
        "| Betty Smith  | Rachel Breecher | Bench Warmer         | 12/21/2012 |\n" +
        "| Candice Yarn | Ralph Colbert   | Candy Tester         | 12/21/2012 |"
    end

    it "should generate a report in CSV format" do
      pending "Restarting project"
      reportgenerator = ApplicationReportGenerator.new

      report = reportgenerator.generate_from(@submissionrecordlist)

      report.to_csv.should ==
        "Jobseeker,Recruiter,Job Title,Date\n" + 
        "Alice Green,Rudy Allen,Applied Technologist,12/21/2012\n" +
        "Betty Smith,Rachel Breecher,Bench Warmer,12/21/2012\n" +
        "Candice Yarn,Ralph Colbert,Candy Tester,12/21/2012\n"
    end

    it "should generate a report in HTML format" do
      pending "Restarting project"
      reportgenerator = ApplicationReportGenerator.new

      report = reportgenerator.generate_from(@submissionrecordlist)

      report.to_html.should ==
        "<table>\n" +
        "<tr><th>Jobseeker</th><th>Recruiter</th><th>Job Title</th><th>Date</th></tr>\n" + 
        "<tr><td>Alice Green</td><td>Rudy Allen</td><td>Applied Technologist</td><td>12/21/2012</td></tr>\n" +
        "<tr><td>Betty Smith</td><td>Rachel Breecher</td><td>Bench Warmer</td><td>12/21/2012</td></tr>\n" +
        "<tr><td>Candice Yarn</td><td>Ralph Colbert</td><td>Candy Tester</td><td>12/21/2012</td></tr>\n" +
        "</table>"
    end
  end
end
