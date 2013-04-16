Feature: Edit a todo
  In order to be able to maintain a list of todos
  As a user
  I want to be able to edit a todo after I've created it 

  Scenario: Edit a todo
    Given I am logged in
    And a todo "Buy groceries +dinner @store" exists in the Active list 
    When I click the edit button
    And I enter a new description of "Buy milk @walmart +quiche"
    Then the Active Todos table should contain "Buy milk +quiche @walmart"

  Scenario: Edit a completed todo
    Given I am logged in
    And a todo "Buy groceries +dinner @store" exists in the Completed list 
    When I click the edit button
    And I enter a new description of "Buy milk @walmart +quiche"
    Then the Completed Todos table should contain "Buy milk +quiche @walmart"
    Then I should see "+quiche" and "+dinner" in the "Project" dropdown
    And I should see "@walmart" and "@store" in the "Context" dropdown
