Feature: Complete todo 
  In order to be able to maintain a list of todos
  As a user
  I want to be able to mark a todo as completed 

  Scenario: Complete a todo
    Given I am logged in
    And a todo exists in the default list 
    When I mark the todo as complete 
    Then it should be crossed-out 
    And it should disappear from the list on later viewings
