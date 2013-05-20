Feature: Toggle tickler status
  In order to be able to maintain a list of todos
  As a user
  I want to be able to move a todo into the 'tickler' file

  Scenario: Move a todo into tickler
    Given I am logged in
    And a todo "A New Todo" exists in the Active list 
    When I click the tickler button for todo #1
    Then it should disappear from the "Active" list 
    And appear on the "Tickler" list as "A New Todo"

  Scenario: Move a todo out of tickler
    Given I am logged in
    And a todo "A New Todo" exists in the Tickler list 
    When I click the tickler button for todo #1
    Then it should disappear from the "Tickler" list 
    And appear on the "Active" list as "A New Todo"
