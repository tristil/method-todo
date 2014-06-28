When(/I click the tickler button for todo #(\d+)/) do |todo_id|
  click_link "todo-tickler-#{todo_id}"
end
