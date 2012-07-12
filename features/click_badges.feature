Feature: Click on badges to filter todos
  Scenario: Click on Context badge
  Given I am logged in
  And there exists a todo with description of "Buy groceries +quiche @store"
  And there exists a todo with description of "Write report +project @work"
  When I click a badge for "@store"
  Then the Active Todos table should only contain "Buy groceries +quiche @store"
  And the context dropdown should read '@store'
  And the filter header should read 'Active @store'
