require 'acceptance/spec_helper'

feature'deleting todos', js: true do

  scenario 'It removes the todo' do
    user = create_user
    create_todo(user: user, description: 'Existing todo')
    log_in_as_user(user)
    should_see_todos_table
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

  def create_todo(description: 'A new todo', user: nil)
    todo = Todo.new(description: description)
    todo.user = user
    todo.save!
    todo
  end

  def should_see_todos_table
    page.should have_table('todo-list-table')
  end

end
