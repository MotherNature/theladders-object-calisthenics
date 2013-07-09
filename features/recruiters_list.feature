Feature: See Jobs
  In order to keep track of my work
  As a Recruiter
  I want to see a list of Jobs that I have posted

  Scenario: Filtered list of Jobs
    Given a first Recruiter with Name "Jane Doe"
    Given a second Recruiter with Name "Vincent Price"
    And an empty JobList
    When the first Recruiter posts a first Job to the JobList
    And the second Recruiter posts a second Job to the JobList
    And the first Recruiter asks for a list of Jobs that they posted
    Then the returned JobList should only contain the first Job
