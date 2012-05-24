Feature: Filter todos by context, project and/or tags
  In order to be able to maintain a list of todos
  As a user
  I want to be able to filter todos by a number of criteria 

  Scenario: View todos for a given context
    Given I am logged in
    And there exists a todo with description of "Buy groceries @store"
    And there exists a todo with description of "Write report @work"
    When I select a context option of "@work"
    Then the Active Todos table should only contain "Write report @work"

  Scenario: View todos for a given project
    Given I am logged in
    And there exists a todo with description of "Buy groceries +quiche"
    And there exists a todo with description of "Write report +project"
    When I select a context option of "+quiche"
    Then the Active Todos table should only contain "Buy groceries +quiche"

  Scenario: View todos for a given project and context combined 
    Given I am logged in
    And there exists a todo with description of "Buy groceries +quiche @store"
    And there exists a todo with description of "Write report +project @work"
    When I select a project option of "+quiche"
    And I select a context option of "@store"
    Then the Active Todos table should only contain "Buy groceries +quiche @store"

  Scenario: Select All button after filtering todos
    Given I am logged in
    And there exists a todo with description of "Buy groceries +quiche @store"
    And there exists a todo with description of "Write report +project @work"
    When I select a project option of "+quiche"
    And I select a context option of "@store"
    And I click the All todos button 
    Then the Active Todos table should contain "Buy groceries +quiche @store"
    And the Active Todos table should contain "Write report +project @work"
