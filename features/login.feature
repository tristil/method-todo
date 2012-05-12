Feature: User signup and login
  In order to be able to save information 
  As a user
  I want to be able to create an account and login

  Scenario: Initial welcome 
    Given I have arrived on the front page
    And I am not logged in
    Then the page should provide an option to log in with message "Login"
    And the page should provide an option to sign in with message "Signup"

  Scenario: Signing Up
    Given I have arrived on the front page
    And I am not logged in
    When I select the option to create an account
    Then I should be taken to the signup page 
    And when I fill in the form with username, email, password, password confirmation fields
    And submit the Sign up form
    Then I should be logged in

  Scenario: Logging in
    Given I have arrived on the front page
    And I have a previously created account
    And I am not logged in
    When I select the option to log in 
    Then I should be taken to the login page 
    And when I fill in the form with email, password fields
    And submit the Sign in form
    Then I should be logged in
