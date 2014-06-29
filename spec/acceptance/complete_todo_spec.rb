require 'acceptance/spec_helper'

feature 'Completing a todo', js: true do
  scenario 'Marks the todo as completed and moves it to the completed list ' do
    user = create_user
    visit root_path
    log_in_as_user(user)
    todo = create_todo(description: 'A New Todo')
    mark_todo_as_completed(todo.id)
    todos_table_should_be_empty

    switch_to_tab('completed')
    should_see_todos("A New Todo #{Time.now.strftime('%-m/%d/%Y')}")

    # Un-complete the todo
    unmark_todo_as_completed(todo.id)
    todos_table_should_be_empty

    switch_to_tab('active')
    should_see_todos('A New Todo')
  end
end
