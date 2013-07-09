Feature: Post Job
  In order to offer Jobs to Jobseekers
  As a Recruiter
  I want to post Jobs to TheLadders

  Scenario: Post simple ATS Job
    Given a Recruiter with Name "Jane Doe"
    And an empty PostingList
    When the Recruiter posts a Job titled "Simple Job" of Type "ATS" to the PostingList
    Then the PostingList should contain a Posting of the Job by the Recruiter
