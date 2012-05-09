Feature: User signup and login
  In order to be able to save information 
  As a user
  I want to be able to create an account and login

  Scenario: Initial welcome 
    Given I have arrived on the front page
    And I am not logged in
    Then the page should provide an option to log in
