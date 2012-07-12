Given /a (completed )?todo "(.*?)" exists in the (Active|Completed) list/ do |completed, description, list|
  @description = description
  user = User.find_by_email 'newuser@example.com'
  @todo = Todo.new :description => description
  @todo.user = user
  if list == 'Completed'
    @todo.complete
  end
  @todo.save
  @todo.parse
  visit(root_path)
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

When /I click on the (Active|Completed) tab/ do |list|
  click_link("#{list.downcase}-tab")
end

And /appear on the "(.*?)" list as "(.*?)"/ do |list_name, description|
  now = Time.now

  description = Time.now.strftime(description)

  list = list_name.downcase
  click_link("#{list}-tab")
  find(:css, "##{list}-todos-list").should have_content(description)
end

Then /the (Active|Completed) table should be visible/ do |list|
  find(:css, "##{list.downcase}-todos-list").should be_visible
end

Then /the (Active|Completed) table should not be visible/ do |list|
  find(:css, "##{list.downcase}-todos-list").should_not be_visible
end
