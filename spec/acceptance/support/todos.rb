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
  end
end
