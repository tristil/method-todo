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
end

