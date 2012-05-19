require 'spec_helper'

describe TodoContextsController do
  it "should redirect to / if user is not logged in" do
    get :index
    response.should be_redirect
  end

  it "should show contexts for todos" do
    user = create_and_login_user
    todo = Todo.new(:description => 'A New Todo')
    todo_context = TodoContext.create(:name => 'work')
    todo_context.user = user
    todo_context.save
    todo.todo_contexts << todo_context
    user.todos << todo
    user.save
    get :index
    ActiveSupport::JSON.decode(response.body).should == ['work']
  end
end
