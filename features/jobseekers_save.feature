Feature: Save Job
  In order to keep track of the jobs to which I want to apply
  As a Jobseeker
  I want to save Jobs to the Site

  Scenario: Save Job
    Given a Jobseeker with Name "Jane Doe"
    And a Recruiter with Name "Robert Smith"
    And an empty PostingList
    And an empty SavedJobList
    When the Recruiter posts a Job titled "Simple Job" of JobType "ATS" to the PostingList
    And the Jobseeker saves the Job to the SavedJobList
    Then the SavedJobList should contain the Job
