Feature: As a end-to-end tester, I want to change the time on the NTP server through a rest interface.

@admin.host.S1
Scenario: Rest status
  Given I have an NTP service that is running on localhost
  And an admin rest server is running on localhost
  When I request the status from the rest server
  Then the status is "listening..."

@admin.host.S2
Scenario Outline: Change time
  Given I have an NTP service that is running on localhost
  And an admin rest server is running on localhost
  When I request to set the time to "<date-time>" in the rest server
  And I request the time from it
  Then the time is near to "<date-time>"
  Examples:
    | date-time                 |
    | 2015/01/01T01:01:01 -0700 |
    | 2017/01/01T01:01:01 -0700 |

@admin.host.S3
Scenario Outline: Reset time
  Given I have an NTP service that is running on localhost
  And an admin rest server is running on localhost
  When I request to set the time to "<date-time>" in the rest server
  And I request to reset the time in the rest server
  And I request the time from it
  Then the time is near to now
  Examples:
    | date-time                 |
    | 2015/01/01T01:01:01 -0700 |
    | 2017/01/01T01:01:01 -0700 |

