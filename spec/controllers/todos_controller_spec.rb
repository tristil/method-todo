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
    response.body.should == [
      {"id" => 1, "description" => "A New Todo","completed" => false,
       "tickler" => false}].to_json
  end

  it "GET to /todos/1 should return json for first todo" do
    user = create_and_login_user
    todo = Todo.create :description => 'A New Todo'
    user.todos << todo
    user.save
    xhr :get, :show, :id => 1
    response.body.should_not =~ /html/;
    response.body.should == {
      "id" => 1, "description" => "A New Todo", "completed" => false,
      "tickler" => false}.to_json
  end

  it "GET to /todos?completed=1 should return json of completed todos" do
    user = create_and_login_user
    todo = Todo.create :description => 'A New Todo'
    todo2 = Todo.create :description => 'Another Todo'
    todo2.complete
    user.todos << todo
    user.todos << todo2
    user.save

    xhr :get, :index, :completed => 1
    response.body.should_not =~ /html/;
    response.body.should =~ /Another Todo/;
    response.body.should_not =~ /A New Todo/;
  end

  it "GET to /todos?completed=1 should be sorted by completed_time" do
    user = create_and_login_user
    todo = Todo.create :description => 'A New Todo'
    todo2 = Todo.create :description => 'Another Todo'
    todo3 = Todo.create :description => 'A Third Todo'

    Timecop.freeze(DateTime.new(2012, 5, 1, 1)) do
      todo2.complete
    end
    Timecop.freeze(DateTime.new(2012, 5, 1, 2)) do
      todo.complete
    end
    Timecop.freeze(DateTime.new(2012, 5, 1, 3)) do
      todo3.complete
    end

    user.todos << todo
    user.todos << todo2
    user.todos << todo3
    user.save

    xhr :get, :index, :completed => 1
    ActiveSupport::JSON.decode(response.body).should == [
      {"id"=>3, "description"=>"A Third Todo <span class='completed-badge label label-default label-inverse'>5/01/2012</span>", "completed"=>true, "tickler" => false},
      {"id"=>1, "description"=>"A New Todo <span class='completed-badge label label-default label-inverse'>5/01/2012</span>", "completed"=>true, "tickler" => false},
      {"id"=>2, "description"=>"Another Todo <span class='completed-badge label label-default label-inverse'>5/01/2012</span>", "completed"=>true, "tickler" => false}
    ]
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

  it "PUT to /todos/1 should update todo" do
    user = create_and_login_user
    todo = Todo.create :description => 'A New Todo'
    user.todos << todo
    user.save
    put :update, {:id => todo.id, :description => 'A New Todo +report'}
    todo = Todo.find_by_id todo.id
    todo.project.should_not be nil
    todo.project.name.should == 'report'
  end

  it "PUT to /todos/1/toggle_tickler_status updates tickler status" do
    user = create_and_login_user
    todo = Todo.create :description => 'A New Todo'
    user.todos << todo
    user.save
    put :toggle_tickler_status, {:id => todo.id}
    todo = Todo.find_by_id todo.id
    todo.tickler.should == true
    put :toggle_tickler_status, {:id => todo.id}
    todo = Todo.find_by_id todo.id
    todo.tickler.should == false
  end
end
