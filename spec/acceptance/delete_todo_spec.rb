require 'acceptance/spec_helper'

feature'deleting todos', js: true do

  scenario 'It removes the todo and adds another' do
    user = create_user
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

  def log_in_as_user(user, password: 'Password1')
    visit(root_path)
    page.should_not have_content "Welcome, "
    click_link("login-link")
    fill_in('user[email]', with: user.email)
    fill_in('user[password]', with: password)
    click_button 'Sign in'
  end

  def create_user
    User.create!(username: 'Example',
                 email: 'newuser@example.com',
                 password: 'Password1')
  end

  def create_todo(description: 'A new todo')
    fill_in 'todo_description', with: description
    last_todo = Todo.last
    last_id = last_todo ? last_todo.id : 0
    click_button 'add-todo-button'
    expect do
      new_todo = Todo.last
      new_todo.id > last_id if new_todo
    end.to become_true
    Todo.last
  end

  def todos_table_should_be_empty
    should_see_todos(*[])
  end

  def should_see_todos(*todos)
    should_see_todos_table
    trs_css = 'table.todo-list-table tbody tr'
    page.should have_css(trs_css, count: todos.length)
    trs = page.all(trs_css)
    trs.each_with_index do |tr, index|
      todo = todos[index]
      tds = tr.all('td')
      tds[1].text.should == todo
    end
  end

  def should_see_todos_table
    page.should have_css('table.todo-list-table')
  end

end
