module Acceptance
  module Todos
    def create_todo(description: 'A new todo')
      fill_in 'todo_description', with: description
      last_todo = Todo.last
      last_id = last_todo ? last_todo.id : 0
      click_button 'add-todo-button'
      page.should have_css('tr.todo-row', text: description)
      Todo.last
    end

    def todos_table_should_be_empty
      should_see_todos(*[])
    end

    def should_see_todos(*todos)
      should_see_todos_table
      trs_css = 'table.todo-list-table tbody tr'
      page.should have_css(trs_css, count: todos.length)
      todos.each_with_index do |todo, index|
        page.find(
          "table.todo-list-table tr:nth-child(#{index + 1}) td:nth-child(1)",
          text: todo)
      end
    end

    def should_see_todos_table
      page.should have_css('table.todo-list-table')
    end

    def mark_todo_as_completed(id)
      check "todos[#{id}][complete]"
    end

    def mark_todo_as_tickler(id)
      click_link "todo-tickler-#{id}"
    end

    def unmark_todo_as_tickler(id)
      click_link "todo-tickler-#{id}"
    end

    def star_todo(id)
      todo_row(id).find('span[data-todo_star]').click
    end

    def switch_to_tab(type)
      click_link "#{type}-tab"
    end

    def todo_row(id)
      find("[data-todo_id='#{id}']")
    end

    def todo_should_not_be_sortable(id)
      todo_row(id).should_not have_css('span[todo-gripper]')
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
end
