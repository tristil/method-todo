Given /I am logged in/ do
  User.create :username => 'Example', :email => 'newuser@example.com', :password => 'Password1'
  visit('/users/sign_in')
  fill_in('user[email]', :with => 'newuser@example.com')
  fill_in('user[password]', :with => 'Password1')
  click_button('Sign in')
end

When /I enter a todo description of "(.+?)"/ do |description|
  @todo_description = description
  fill_in('todo[description]', :with => description)
  click_button('add-todo-button')
end

Then /a new todo should appear in the default list of todos/ do
  find('#active-todos-list').should have_content(@todo_description)
end

And /the add todo input should have focus/ do
  # This should work but it don't. Sigh.
  #page.driver.evaluate_script("$('#todo_description').is(':focus');").should == true;
end

And /the input should be cleared/ do
  find('#todo_description').value.should == ""
end

And /it should be marked with a (Context|Project) of "(.+?)"/ do |type, context|
  prefix = type == 'Context' ? '@' : '+'
  page.should have_selector(:xpath, "//span[@class='label'][.='#{prefix}#{context}']")
  #page.should_not have_selector(:xpath, "//td[.='#{@todo_description}']")
end
