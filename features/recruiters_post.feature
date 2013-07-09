Feature: Post Job
  In order to offer Jobs to Jobseekers
  As a Recruiter
  I want to post Jobs to TheLadders

  Scenario: Post simple ATS Job
    Given a Recruiter with Name "Jane Doe"
    And an empty JobList
    When the Recruiter posts a Job titled "Simple Job" of Type "ATS" to the JobList
    Then the JobList should contain a Job titled "Simple Job" of Type "ATS"
