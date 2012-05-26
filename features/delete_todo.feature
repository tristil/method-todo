Feature: Delete todo 
  In order to be able to maintain a list of todos
  As a user
  I want to be able to delete a todo 

  Scenario: Delete a todo
    Given I am logged in
    And a todo "A New Todo" exists in the Active list 
    When I select the todo to be deleted
    Then I should receive a popup alert
    And when I agree to delete the todo
    Then it should disappear from the todo list
