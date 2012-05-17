require 'spec_helper'

describe TodosController do
  render_views

  it "should redirect to / if user is not logged in" do
    get :index
    response.should be_redirect
  end

  it "GET to /todos should return only datatable when AJAX, else full page" do
    user = create_and_login_user
    todo = Todo.create! :description => 'A New Todo'
    user.todos << todo
    user.save
    xhr :get, :index
    response.body.should_not =~ /html/;
    get :index
    response.body.should =~ /html/;
  end

  it "GET to /todos/completed should return datatable of completed todos" do
    user = create_and_login_user
    todo = Todo.create! :description => 'A New Todo'
    todo2 = Todo.create! :description => 'Another Todo'
    todo2.complete
    user.todos << todo
    user.todos << todo2
    user.save

    xhr :get, :completed
    response.body.should_not =~ /html/;
    response.body.should =~ /Another Todo/;
    response.body.should_not =~ /A New Todo/;
  end


  it "POST to /todos.json should create new Todo" do
    user = create_and_login_user
    user.todos.should be_empty
    post :create, :todo => {:description => 'A New Todo' }, :format => :json
    user.reload
    user.todos.should_not be_empty
    ActiveSupport::JSON.decode(response.body).should == {'created' => true, "new_id" => 1}
  end

  it "POST to /todos/1/complete should mark Todo as complete" do
    user = create_and_login_user
    todo = Todo.create! :description => 'A New Todo'
    user.todos << todo
    user.save
    put :complete, {:id => todo.id.to_s}
    user.reload
    user.todos[0].completed.should be_true
  end

  it "POST to /todos/1/complete with complete=0 should mark Todo as incomplete" do
    user = create_and_login_user
    todo = Todo.create! :description => 'A New Todo'
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
    todo = Todo.create! :description => 'A New Todo'
    todo.save
    user.todos << todo
    user.save
    delete :destroy, :id => todo.id
    user.reload
    user.todos.should be_empty
  end

end
