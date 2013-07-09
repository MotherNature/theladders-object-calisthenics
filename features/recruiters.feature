Feature: Post Job
  In order to offer Jobs to Jobseekers
  As a Recruiter
  I want to post Jobs to TheLadders

  Scenario: Post simple ATS Job
    Given a Recruiter with Name "Jane Doe"
    And an empty JobList
    When the Recruiter posts a Job titled "Simple Job" of Type "ATS" to the JobList
    Then the JobList should contain a Job titled "Simple Job" of Type "ATS"

Feature: See Jobs
  In order to keep track of my work
  As a Recruiter
  I want to see a list of Jobs that I have posted

  Scenario: Basic list of Jobs
    Given a Recruiter with Name "Jane Doe"
    And an empty JobList
    When the Recruiter posts a Job titled "Simple Job" of Type "ATS" to the JobList
    And the Recruiter asks for a list of Jobs that they posted
    Then the returned JobList should only contain a Job titled "Simple Job" of Type "ATS"
