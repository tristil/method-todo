Feature: Add a todo
  In order to be able to maintain a list of todos
  As a user
  I want to be able to add a todo to work on

  Scenario: Add a todo
    Given I am logged in
    When I enter a todo description
    Then a new todo should appear in the default list of todos
    And the add todo input should have focus
    And the input should be cleared
