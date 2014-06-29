require 'acceptance/spec_helper'

feature 'Tickler tab', js: true do
  scenario 'Move todo into tickler and back out' do
    user = create_user
    visit root_path
    log_in_as_user(user)
    todo = create_todo(description: 'A tickler todo')

    mark_todo_as_tickler(todo.id)
    todos_table_should_be_empty
    switch_to_tab('tickler')
    should_see_todos('A tickler todo')

    unmark_todo_as_tickler(todo.id)
    todos_table_should_be_empty
    switch_to_tab('active')
    should_see_todos('A tickler todo')
  end
end
