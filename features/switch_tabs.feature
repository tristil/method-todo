Feature: Switch between tabs
  In order to be able to maintain a list of todos
  As a user
  I want to be able to switch between active, completed and tickler tabs 

  Scenario: Switch to completed tab
    Given I am logged in
    And a todo "A New Todo" exists in the Active list 
    And a todo "An Old Todo" exists in the Completed list 
    When I have arrived on the front page
    And I click on the Completed tab
    Then the Completed table should be visible
    And the Active table should not be visible
    And the filter header should read 'Showing: All Completed Todos'

  Scenario: Switch to tickler tab 
    Given I am logged in
    And a todo "A New Todo" exists in the Tickler list 
    When I have arrived on the front page
    And I click on the Tickler tab
    Then the Completed table should not be visible
    And the Active table should not be visible
    And the Tickler table should be visible
    And the filter header should read 'Showing: All Tickler Todos'
