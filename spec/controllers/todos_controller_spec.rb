require 'spec_helper'

describe TodosController do
  render_views

  it "should redirect to / if user is not logged in" do
    get :index
    response.should be_redirect
  end

  it "GET to /todos should return json of active todos" do
    user = create_and_login_user
    todo = Todo.create :description => 'A New Todo'
    user.todos << todo
    user.save
    xhr :get, :index
    response.body.should_not =~ /html/;
    response.body.should == "[{\"id\":1,\"description\":\"A New Todo\"}]"
  end

  it "GET to /todos/completed should return json of completed todos" do
    user = create_and_login_user
    todo = Todo.create :description => 'A New Todo'
    todo2 = Todo.create :description => 'Another Todo'
    todo2.complete
    user.todos << todo
    user.todos << todo2
    user.save

    xhr :get, :completed
    response.body.should_not =~ /html/;
    response.body.should =~ /Another Todo/;
    response.body.should_not =~ /A New Todo/;
  end


  it "POST to /todos should create new Todo" do
    user = create_and_login_user
    user.todos.should be_empty
    post :create, :todo => {:description => 'A New Todo' }, :format => :json
    user.reload
    user.todos.should_not be_empty
    ActiveSupport::JSON.decode(response.body).should == {"id"=>1, "description"=>"A New Todo", "saved"=>true}
  end

  it "POST to /todos/1/complete should mark Todo as complete" do
    user = create_and_login_user
    todo = Todo.create :description => 'A New Todo'
    user.todos << todo
    user.save
    put :complete, {:id => todo.id.to_s}
    user.reload
    user.todos[0].completed.should be_true
  end

  it "POST to /todos/1/complete with complete=0 should mark Todo as incomplete" do
    user = create_and_login_user
    todo = Todo.create :description => 'A New Todo'
    todo.complete
    todo.save
    user.todos << todo
    user.save
    put :complete, {:id => todo.id.to_s, :complete => 0}
    user.reload
    user.todos[0].completed.should be_false
  end

  it "DELETE to /todos/1 should remove Todo" do
    user = create_and_login_user
    todo = Todo.create :description => 'A New Todo'
    todo.save
    user.todos << todo
    user.save
    delete :destroy, :id => todo.id
    user.reload
    user.todos.should be_empty
  end

  it "GET to /contexts/1/todos should return a datatable or JSON based on context" do
    user = create_and_login_user
    context1= TodoContext.create :name => 'work'
    context2 = TodoContext.create :name => 'home'

    todo = Todo.create :description => 'A New Todo'
    todo.todo_contexts << context1
    user.todos << todo

    todo2 = Todo.create :description => 'Another Todo'
    todo2.todo_contexts << context2
    user.todos << todo2

    user.save

    xhr :get, :index, :context_id => 1
    response.body.should_not =~ /html/;
    response.body.should =~ /A New Todo/
    response.body.should_not =~ /Another Todo/
  end

  it "GET to /projects/1/todos should return a datatable or JSON based on context" do
    user = create_and_login_user
    project1 = Project.create :name => 'TP Report'
    project2 = Project.create :name => 'Other Report'

    todo = Todo.create :description => 'A New Todo'
    todo.project = project1
    user.todos << todo

    todo2 = Todo.create :description => 'Another Todo'
    todo2.project = project2
    user.todos << todo2

    user.save

    xhr :get, :index, :project_id => 1
    response.body.should_not =~ /html/;
    response.body.should =~ /A New Todo/
    response.body.should_not =~ /Another Todo/
  end
end
