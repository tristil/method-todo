Feature: Show contexts and projects
  In order to be able to maintain a list of todos
  As a user
  I want to be able to see and select active contexts and projects on front page 

  Scenario: See contexts and projects
    Given I am logged in
    When I enter a todo description of "Brainstorm @home +report"
    And  I enter a todo description of "Write first draft @work +report" 
    And  I enter a todo description of "Buy eggs +quiche" 
    Then I should see "+report" and "+quiche" in the "Project" dropdown
    And I should see "@home" and "@work" in the "Context" dropdown
