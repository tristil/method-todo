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

Then /it should not be crossed-out/ do
  todo = find(:xpath, '//span[@id="todo-1"][not(contains(@class, "struck-through"))]')
end

When /I uncheck the todo/ do
  uncheck('todos[1][complete]')
end

And /it should disappear from the list when I refresh/ do
  visit('/')
  page.should_not have_content('A New Todo')
end

And /it should still be on the default list when I refresh/ do
  visit('/')
  page.should have_content('A New Todo')
end
