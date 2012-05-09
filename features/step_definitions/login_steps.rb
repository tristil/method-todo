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

Then /I should be taken to the signup page/ do
  page.status_code.should == 200
  page.should have_content("Password confirmation")
end

And /when I enter an email and password and submit form/ do
  fill_in('user[email]', :with => 'newuser@example.com')
  fill_in('user[password]', :with => 'Password1')
  fill_in('user[password_confirmation]', :with => 'Password1')
  click_button("Sign up")
end

Then /I should be logged in/ do
  page.should have_content("Welcome!")
end

