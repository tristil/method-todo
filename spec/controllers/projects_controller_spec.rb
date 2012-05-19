require 'spec_helper'

describe ProjectsController do
  it "should redirect to / if user is not logged in" do
    get :index
    response.should be_redirect
  end

  it "should show projects for todos" do
    user = create_and_login_user
    todo = Todo.new(:description => 'A New Todo')
    project = Project.create!(:name => 'TP Report')
    project.user = user
    project.save
    todo.project = project
    user.todos << todo
    user.save
    get :index
    ActiveSupport::JSON.decode(response.body).should == ['TP Report']
  end
end
