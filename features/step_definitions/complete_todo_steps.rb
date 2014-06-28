Given(/a (completed )?todo "(.*?)" exists in the (Active|Completed|Tickler) list/) do |_completed, description, list|
  @description = description
  user = User.find_by_email 'newuser@example.com'
  @todo = Todo.new description: description
  @todo.user = user
  if list == 'Completed'
    @todo.complete
  elsif list == 'Tickler'
    @todo.toggle_tickler_status
  end
  @todo.save!
  @todo.parse
  visit(root_path)
  if list == 'Completed'
    click_link 'completed-tab'
  elsif list == 'Tickler'
    click_link 'tickler-tab'
  end
  find(:css, "##{list.downcase}-todos-list").should have_content(description)
end

When(/I mark the todo as complete/) do
  check('todos[1][complete]')
end

When(/I uncheck the todo/) do
  uncheck('todos[1][complete]')
end

And(/it should disappear from the "(.*?)" list/) do |list_name|
  find(:css, "##{list_name.downcase}-todos-list").should_not have_content(@description)
end

When(/I click on the (Active|Completed|Tickler) tab/) do |list|
  click_link("#{list.downcase}-tab")
end

And(/appear on the "(.*?)" list as "(.*?)"/) do |list_name, description|
  description = Time.now.in_time_zone(0).strftime(description)

  list = list_name.downcase
  click_link("#{list}-tab")
  find(:css, "##{list}-todos-list").should have_content(description)
end

Then(/the (Active|Completed|Tickler) table should be visible/) do |list|
  find(:css, "##{list.downcase}-todos-list").should be_visible
end

Then(/the (Active|Completed|Tickler) table should not be visible/) do |list|
  page.should_not have_selector(:css, "##{list.downcase}-todos-list")
end
