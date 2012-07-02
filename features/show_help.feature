Feature: Show help 
  In order to be able to maintain a list of todos
  As a user
  I want to see help at the top of the screen

  Scenario: See help 
    Given I am logged in
    And I should see help text 
    When I dismiss the help text it should disappear
    And when I return to the page it should be closed
