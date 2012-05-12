Given /I have arrived on the front page/ do
  visit('/')
end

And /I am not logged in/ do
  # I guess I can't test this from here
end

Then /the page should provide an option to (.*?) with message "(.*?)"/ do |action, message|
  page.should have_content(message)
end

When /I select the option to create an account/ do
  click_link("signup-link")
end

When /I select the option to log in/ do
  click_link("login-link")
end

Then /I should be taken to the signup page/ do
  page.status_code.should == 200
  page.should have_content("Password confirmation")
end

Then /I should be taken to the login page/ do
  page.status_code.should == 200
  page.should_not have_content("Password confirmation")
end

And /when I enter an email, password(.*?) and submit form/ do |confirmation|
  fill_in('user[email]', :with => 'newuser@example.com')
  fill_in('user[password]', :with => 'Password1')
  if confirmation == " and password confirmation"
    fill_in('user[password_confirmation]', :with => 'Password1')
    click_button("Sign up")
  else
    click_button("Sign in")
  end
end

Then /I should be logged in/ do
  page.should have_content("Account")
end

And /I have a previously created account/ do
  User.create! :email => 'newuser@example.com', :password => 'Password1'
end
