require 'spec_helper'

describe TodoContextsController do
  it 'should redirect to / if user is not logged in' do
    get :index
    response.should be_redirect
  end

  it 'should show contexts for todos' do
    user = create_and_login_user
    todo = Todo.create(description: 'A New Todo')
    todo_context = TodoContext.create(name: 'work')
    todo_context.user = user
    todo_context.save
    todo.todo_contexts << todo_context
    user.todos << todo
    get :index
    ActiveSupport::JSON.decode(response.body)
      .should == [{ 'id' => 1, 'name' => 'work' }]
  end

  it 'should delete context from all todos' do
    user = create_and_login_user
    todo = Todo.create(description: 'Buy milk @store')
    todo.user = user
    todo.parse
    todo.save
    delete :destroy, id: 1
    todo.reload
    todo.todo_contexts.should be_empty
    todo.description.should == 'Buy milk'
  end
end
