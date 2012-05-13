require 'spec_helper'

describe TodosController do
  it "POST to /todos.json should create new Todo" do
    user = create_and_login_user
    user.todos.should be_empty
    post :create, :todo => {:description => 'A New Todo' }
    user.reload
    user.todos.should_not be_empty
  end

  it "POST to /todos/1/complete should mark Todo as complete" do
    user = create_and_login_user
    todo = Todo.create! :description => 'A New Todo'
    user.todos << todo
    user.save
    put :complete, {:id => todo.id.to_s, :completed => 1}
    user.reload
    user.todos[0].completed.should be_true
  end

end
