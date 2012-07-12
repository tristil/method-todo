Feature: Switch from active to completed tabs
  In order to be able to maintain a list of todos
  As a user
  I want to be able to switch between active and completed tabs 

  Scenario: Switch to completed tabs 
    Given I am logged in
    And a todo "A New Todo" exists in the Active list 
    And a todo "An Old Todo" exists in the Completed list 
    When I have arrived on the front page
    And I click on the Completed tab
    Then the Completed table should be visible
    And the Active table should not be visible
    And the filter header should read 'All Completed'
