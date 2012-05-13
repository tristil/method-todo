Given /I am logged in/ do
  User.create! :username => 'Example', :email => 'newuser@example.com', :password => 'Password1'
  visit('/users/sign_in')
  fill_in('user[email]', :with => 'newuser@example.com')
  fill_in('user[password]', :with => 'Password1')
  click_button('Sign in')
end

When /I enter a todo description/ do
  fill_in('todo[description]', :with => 'A New Todo')
  click_button('Add Todo')
end

Then /a new todo should appear in the default list of todos/ do
  find('#todos-list').should have_content('A New Todo')
end
