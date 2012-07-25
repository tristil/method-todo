Feature: Remove a filter
  In order to be able to maintain a list of todos
  As a user
  I want to be able to remove a filter from the system completely 

  Scenario: View a filter management screen
    Given I am logged in
    And a todo "Buy groceries +dinner @store" exists in the Active list 
    When I click "Manage..." on the Context menu
    Then the filter management menu for Contexts should appear

