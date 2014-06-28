require 'spec_helper'

describe ProjectsController do
  it 'should redirect to / if user is not logged in' do
    get :index
    response.should be_redirect
  end

  it 'should show projects for todos' do
    user = create_and_login_user
    todo = Todo.new(description: 'A New Todo')
    project = Project.create(name: 'TP Report')
    project.user = user
    project.save
    todo.project = project
    user.todos << todo
    get :index
    ActiveSupport::JSON.decode(response.body)
      .should == [{ 'id' => 1, 'name' => 'TP Report' }]
  end

  it 'should delete project from all todos' do
    user = create_and_login_user
    todo = Todo.create(description: 'Buy milk +quiche')
    todo.user = user
    todo.parse
    todo.save
    delete :destroy, id: 1
    todo.reload
    todo.project.should be_nil
    todo.description.should == 'Buy milk'
  end

end
