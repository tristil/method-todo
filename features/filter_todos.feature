Feature: Filter todos by context, project and/or tags
  In order to be able to maintain a list of todos
  As a user
  I want to be able to filter todos by a number of criteria 

  Scenario: View todos for a given context
    Given I am logged in
    And there exists a todo with description of "Buy groceries @store"
    And there exists a todo with description of "Write report @work"
    When I have arrived on the front page
    And I select a context option of "@work"
    Then the Active Todos table should only contain "Write report @work"
    And the context dropdown should read '@work'
    And the filter header should read 'Active @work'

  Scenario: View todos for a given project
    Given I am logged in
    And there exists a todo with description of "Buy groceries +quiche"
    And there exists a todo with description of "Write report +project"
    When I have arrived on the front page
    And I select a context option of "+quiche"
    Then the Active Todos table should only contain "Buy groceries +quiche"
    And the project dropdown should read '+quiche'
    And the filter header should read 'Active +quiche'

  Scenario: View todos for a given project and context combined 
    Given I am logged in
    And there exists a todo with description of "Buy groceries +quiche @store"
    And there exists a todo with description of "Write report +project @work"
    When I have arrived on the front page
    And I select a project option of "+quiche"
    And I select a context option of "@store"
    Then the Active Todos table should only contain "Buy groceries +quiche @store"
    And the context dropdown should read '@store'
    And the tag dropdown should read 'Tag'
    And the project dropdown should read '+quiche'
    And the filter header should read 'Active @store, +quiche' header

  Scenario: Select All button after filtering todos
    Given I am logged in
    And there exists a todo with description of "Buy groceries +quiche @store"
    And there exists a todo with description of "Write report +project @work"
    When I have arrived on the front page
    And I select a project option of "+quiche"
    And I select a context option of "@store"
    And I click the All todos button 
    Then the Active Todos table should contain "Buy groceries +quiche @store"
    And the Active Todos table should contain "Write report +project @work"
    And the filter header should read 'All Active'
