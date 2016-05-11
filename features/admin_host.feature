@admin.host
Feature: As a end-to-end tester, I want to change the time on the NTP server through a rest interface.

@admin.host.S1
Scenario: Rest status
  When I request the status from the rest server
  Then the status is "listening..."

@admin.host.S2
Scenario Outline: Change time
  When I request to set the date to "<date>" and time to "<time>" in the rest server
  And I request the time from it
  Then the time is near to "<date>T<time>"
  Examples:
    | date       | time     |
    | 2015-01-01 | 01:01:01 |
    | 2017-01-01 | 01:01:01 |

@admin.host.S3
Scenario Outline: Reset time
  When I request to set the date to "<date>" and time to "<time>" in the rest server
  And I request to reset the time in the rest server
  And I request the time from it
  Then the time is near to now
  Examples:
    | date       | time     |
    | 2015-01-01 | 01:01:01 |
    | 2017-01-01 | 01:01:01 |

@admin.host.S4
Scenario: Check the healthcheck status
  When I check the "/healthcheck"
  Then the status is "Good"
