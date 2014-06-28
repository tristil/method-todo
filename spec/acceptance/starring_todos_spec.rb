require 'acceptance/spec_helper'

feature 'Starring todos', js: true do
  it 'allows starring a todo so it will always be on top' do
    user = create_user
    visit root_path
    log_in_as_user(user)
    todo1 = create_todo(description: 'Todo 1')
    todo2 = create_todo(description: 'Todo 2')
    todo3 = create_todo(description: 'Todo 3')
    should_see_todos('Todo 3', 'Todo 2', 'Todo 1')

    # Goes to top when starred
    star_todo(todo2.id)
    should_see_todos('Todo 2', 'Todo 3', 'Todo 1')
    visit current_path
    should_see_todos('Todo 2', 'Todo 3', 'Todo 1')

    # Should remain in place when dragged
    drag_todo(target_id: todo2.id, steps: 1)
    should_see_todos('Todo 2', 'Todo 3', 'Todo 1')
    visit current_path
    should_see_todos('Todo 2', 'Todo 3', 'Todo 1')

    # Should add new todos after starred todos
    create_todo(description: 'Todo 4')

    # Should preserve order among starred todos
    star_todo(todo1.id)
    star_todo(todo3.id)
    should_see_todos('Todo 3', 'Todo 2', 'Todo 1', 'Todo 4')
    drag_todo(target_id: todo3.id, steps: 1)
    should_see_todos('Todo 2', 'Todo 3', 'Todo 1', 'Todo 4')
    visit current_path
    should_see_todos('Todo 2', 'Todo 3', 'Todo 1', 'Todo 4')
  end
end
