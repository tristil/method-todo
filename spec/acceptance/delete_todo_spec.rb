require 'acceptance/spec_helper'

feature'deleting todos', js: true do
  scenario 'It removes the todo and adds another' do
    user = create_user
    visit root_path
    log_in_as_user(user)
    todo = create_todo(description: 'Existing todo')
    should_see_todos('Existing todo')
    delete_todo(id: todo.id)
    todos_table_should_be_empty
    create_todo(description: 'A new todo')
    should_see_todos('A new todo')
  end

  def delete_todo(id: nil)
    click_link "todo-delete-#{id}"
    click_delete_on_modal
  end

  def click_delete_on_modal
    within '#delete-todo-modal' do
      click_link 'Delete'
    end
  end
end
