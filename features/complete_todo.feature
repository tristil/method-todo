Feature: Complete todo 
  In order to be able to maintain a list of todos
  As a user
  I want to be able to mark a todo as completed 

  Scenario: Complete a todo
    Given I am logged in
    And a todo exists in the default list 
    When I mark the todo as complete 
    #Then it should be crossed-out 
    And it should disappear from the "Active" list 
    And appear on the "Completed" list

  #Scenario: Uncomplete a todo
  #  Given I am logged in
  #  And a todo exists in the default list 
  #  And I mark the todo as complete 
  #  And it should be crossed-out 
  #  When I uncheck the todo
  #  Then it should not be crossed-out
  #  And it should still be on the default list when I refresh 

