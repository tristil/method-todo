Feature: Add a todo
  In order to be able to maintain a list of todos
  As a user
  I want to be able to add a todo to work on

  Scenario: Add a todo
    Given I am logged in
    When I enter a todo description of "A New Todo"
    Then a new todo should appear in the default list of todos
    And the add todo input should have focus
    And the input should be cleared

  Scenario: Add a todo with @context
    Given I am logged in
    When I enter a todo description of "Write report @work"
    Then a new todo should appear in the default list of todos
    And it should be marked with a Context of "work"

  Scenario: Add a todo with +project
    Given I am logged in
    When I enter a todo description of "Write report +bigreport"
    Then a new todo should appear in the default list of todos
    And it should be marked with a Project of "bigreport"

  Scenario: Add a todo with multiple @contexts
    Given I am logged in
    When I enter a todo description of "Write report @work @home"
    Then a new todo should appear in the default list of todos
    And it should be marked with a Context of "work"
    And it should be marked with a Context of "home"
