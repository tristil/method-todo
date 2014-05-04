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
  end

  def drag_todo(target_id: nil, steps: nil)
    page.execute_script(<<-JS
      var head = document.getElementsByTagName('head')[0];
      var script = document.createElement('script');
      script.src = '/assets/test.js';
      head.appendChild(script);
      $("tr[data-todo_id='#{target_id}']")
        .simulateDragSortable({ move: #{steps}, handle: 'span[todo-gripper]' });
    JS
    )
  end
end
