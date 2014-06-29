require 'acceptance/spec_helper'

feature 'Switch tabs', js: true do
  scenario 'Shows different sets of todos' do
    user = create_user
    visit root_path
    log_in_as_user(user)
    create_todo(description: 'An active todo')
    todo = create_todo(description: 'A completed todo')
    mark_todo_as_completed(todo.id)
    todo2 = create_todo(description: 'A tickler todo')
    mark_todo_as_tickler(todo2.id)

    should_see_todos('An active todo')
    switch_to_tab('tickler')
    should_see_todos('A tickler todo')
    switch_to_tab('completed')
    should_see_todos('A completed todo')
  end
end
