Given /a todo exists in the default list/ do
  user = User.find_by_email 'newuser@example.com'
  todo = Todo.new :description => 'A New Todo'
  todo.user_id = user.id
  todo.save
  visit('/')
end

When /I mark the todo as complete/ do
  check('todos[1][complete]')
end

Then /it should be crossed-out/ do
  todo = find(:xpath, '//span[@id="todo-1"][@class="struck-through"]')
end

And /it should disappear from the list on later viewings/ do
  visit('/')
  page.should_not have_content('A New Todo')
end
