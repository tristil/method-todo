require 'acceptance/spec_helper'

feature 'Sorting todos', js: true do
  it 'allows changing the order of todos' do
    user = create_user
    visit root_path
    log_in_as_user(user)
    todo1 = create_todo(description: 'Todo 1')
    todo2 = create_todo(description: 'Todo 2')
    should_see_todos('Todo 2', 'Todo 1')

    # Reorder todos
    drag_todo(target_id: todo1.id, steps: 1)
    should_see_todos('Todo 2', 'Todo 1')

    # Ensure new todo occurs at top
    todo3 = create_todo(description: 'Todo 3')
    should_see_todos('Todo 3', 'Todo 2', 'Todo 1')

    # Ensure things look okay after reload
    visit current_path
    should_see_todos('Todo 3', 'Todo 2', 'Todo 1')

    # Completed todos should not be sortable
    mark_todo_as_completed(todo3.id)
    should_see_todos('Todo 2', 'Todo 1')
    switch_to_tab('completed')
    should_see_todos('Todo 3')
    todo_should_not_be_sortable(todo3.id)

    # Ticklers can be sorted
    switch_to_tab('active')
    mark_todo_as_tickler(todo1.id)
    mark_todo_as_tickler(todo2.id)
    switch_to_tab('tickler')
    should_see_todos('Todo 2', 'Todo 1')
    drag_todo(target_id: todo2.id, steps: 1)
    should_see_todos('Todo 1', 'Todo 2')
    visit current_path
    switch_to_tab('tickler')
    should_see_todos('Todo 1', 'Todo 2')

    # They should preserve order when moved from tickler
    unmark_todo_as_tickler(todo1.id)
    unmark_todo_as_tickler(todo2.id)
    switch_to_tab('active')
    should_see_todos('Todo 1', 'Todo 2')
    visit current_path
    should_see_todos('Todo 1', 'Todo 2')
  end
end
