require 'spec_helper'

describe User do
  it "should require username, email and password" do
      User.new({:username => 'Example', :email => "example1@example.com"}).should have(1).error_on(:password)
      User.new({:email => "example2@example.com", :password => 'Password1'}).should have(1).error_on(:username)
      User.new({:username => 'Example', :email => "example2@example.com", :password => 'Password1'}).should have(0).errors
  end

  it "should ensure username and email are unique" do
      User.create(
        {:username => 'Example', :email => "example@example.com", :password => 'Password1'}
      )
      User.new(
        {:username => 'Example', :email => "example2@example.com", :password => 'Password1'}
      ).should have(1).error_on(:username)
      User.new(
        {:username => 'Example2', :email => "example@example.com", :password => 'Password1'}
      ).should have(1).error_on(:email)
  end

  it ".todos should return todos" do
    user = User.create(:username => "Example", :email => "example@example.com", :password => "Password1")
    todo = Todo.create(:description => "A New Todo")
    user.todos << todo
    user.save
    user = User.find_by_id user.id
    user.todos.should == [todo]
  end

  it ".active_todos should return non-completed todos" do
    user = User.create(:username => "Example", :email => "example@example.com", :password => "Password1")

    todo = Todo.new(:description => "A New Todo")
    todo.user = user
    todo.save!

    todo2 = Todo.new(:description => "A New Todo 2")
    todo2.user = user
    todo2.complete
    todo2.save!

    user.reload
    user.todos.should == [todo, todo2]
    user.active_todos.should == [todo]
  end

  it ".completed_todos should return completed todos" do
    user = User.create(:username => "Example", :email => "example@example.com", :password => "Password1")

    todo = Todo.new(:description => "A New Todo")
    todo.user = user
    todo.save!

    todo2 = Todo.new(:description => "A New Todo 2")
    todo2.user = user
    todo2.complete
    todo2.save!

    user.reload
    user.todos.should == [todo, todo2]
    user.completed_todos.should == [todo2]
  end


  it ".destroy should use Acts as Paranoid to virtually delete the user" do
    user = User.create(:username => "Example", :email => "example@example.com", :password => "Password1")
    user.destroy
    User.all.should == []
    User.only_deleted.should == [user]
  end

  it ".todo_contexts should return contexts for this user" do
    user = User.create(:username => "Example", :email => "example@example.com", :password => "Password1")
    todo = Todo.create(:description => "A New Todo")
    todo_context = TodoContext.create(:name => 'home')
    todo_context.user = user
    todo_context.save
    todo.todo_contexts << todo_context
    todo.save
    user.todos << todo
    user.save
    user.reload
    user.todo_contexts.should == [todo_context]
  end

  it ".projects should return projects  for this user" do
    user = User.create(:username => "Example", :email => "example@example.com", :password => "Password1")
    todo = Todo.create(:description => "A New Todo")
    project = Project.create(:name => 'TP Report')
    project.user = user
    project.save
    todo.project = project
    todo.save
    user.todos << todo
    user.save
    user.reload
    user.projects.should == [project]
  end

  it ".preferences should return and set a hash" do
    user = User.create(:username => "Example", :email => "example@example.com", :password => "Password1")
    user.preferences.should == {}
    user.preferences[:show_help] = false
    user.save
    user.reload
    user.preferences[:show_help].should == false
  end

end
