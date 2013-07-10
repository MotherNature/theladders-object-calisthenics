Feature: Apply to Jobs
  In order to get a Job
  As a Jobseeker
  I want to apply to Jobs on the Site

  Scenario: Apply to an ATS Job
    Given a Jobseeker with Name "Jane Doe"
    And a Recruiter with Name "Robert Smith"
    And an empty PostingList
    And an empty SavedJobRecordList
    And an empty JobApplicationList
    When the Recruiter posts a Job titled "Simple Job" of JobType "ATS" to the PostingList
    And the Jobseeker applies to the Job
    Then the JobApplicationList should list the Job as applied to by the Jobseeker
