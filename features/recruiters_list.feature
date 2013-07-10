Feature: See Jobs
  In order to keep track of my work
  As a Recruiter
  I want to see a list of Jobs that I have posted

  Scenario: Filtered list of Jobs
    Given a first Recruiter with Name "Jane Doe"
    Given a second Recruiter with Name "Vincent Price"
    And an empty PostingList
    When the first Recruiter posts the first Job to the PostingList
    And the second Recruiter posts the second Job to the PostingList
    And the first Recruiter asks for a list of Jobs that they posted
    Then the returned JobList should only contain the first Job
