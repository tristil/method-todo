Feature: Complete todo 
  In order to be able to maintain a list of todos
  As a user
  I want to be able to mark a todo as completed 

  Scenario: Complete a todo
    Given I am logged in
    And a todo "A New Todo" exists in the Active list 
    When I mark the todo as complete 
    And it should disappear from the "Active" list 
    And appear on the "Completed" list as "A New Todo %-m/%d/%Y"

  Scenario: Uncomplete a todo
    Given I am logged in
    And a completed todo "A New Todo" exists in the Completed list
    When I uncheck the todo
    Then it should disappear from the "Completed" list 
    And appear on the "Active" list as "A New Todo"
