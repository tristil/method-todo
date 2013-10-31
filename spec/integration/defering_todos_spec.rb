require 'spec_helper'

feature 'Defering a todo to be shown at a later date', js: true do
  let!(:user) { User.create!(email: 'blah@example.com',
                              username: 'blah12345',
                              password: 'password') }
  let!(:todo) { user.todos.create!(description: 'Do something') }
  let!(:todo2) { user.todos.create!(description: 'Do something else') }

  scenario 'change a visibility date' do
    logs_in_to_site('blah12345', 'password')
    defers_todo(todo, num_days: 4)
    todo_should_not_be_visible(todo)
    come_back_another_day
    todo_should_be_visible(todo)
  end

  def logs_in_to_site(email, password)
    visit '/'
    fill_in 'Password', with: password
    fill_in 'Email', with: email
    click_button 'Sign in'
  end

  def defers_todo(todo, options = {})
    num_days = options.fetch(:num_days)
    click_link "#todo-row-#{todo.id} .defer-link"
    fill_in 'Days to defer', with: num_days
  end

end
