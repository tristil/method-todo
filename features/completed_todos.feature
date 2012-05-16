Feature: View Completed Todos 
  In order to be able to maintain a list of todos
  As a user
  I want to be able to see my completed todos 

  Scenario: View completed todos 
    Given I am logged in
    And a todo exists in the default list
    And I mark the todo as complete
    When I click the Completed Todos Button 
    Then the completed todos list should appear 
    And the completed todo should be present in it
