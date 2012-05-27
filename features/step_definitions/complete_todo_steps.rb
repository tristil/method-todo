Given /a (completed )?todo "(.*?)" exists in the (Active|Completed) list/ do |completed, description, list|
  @description = description
  user = User.find_by_email 'newuser@example.com'
  @todo = Todo.new :description => description
  @todo.user_id = user.id
  if list == 'Completed'
    @todo.complete
  end
  @todo.save
  @todo.parse
  visit('/')
  find(:css, "##{list.downcase}-todos-list").should have_content(description)
end

When /I mark the todo as complete/ do
  check('todos[1][complete]')
end

When /I uncheck the todo/ do
  uncheck('todos[1][complete]')
end
And /it should disappear from the "(.*?)" list/ do |list_name|
  find(:css, "##{list_name.downcase}-todos-list").should_not have_content(@description)
end

And /appear on the "(.*?)" list/ do |list_name|
  list = list_name.downcase
  click_link("#{list}-tab")
  find(:css, "##{list}-todos-list").should have_content(@description)
end
