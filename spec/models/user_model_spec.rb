require 'spec_helper'

describe User do
  it "should require username, email and password" do
      User.new({:username => 'Example', :email => "example1@example.com"}).should have(1).error_on(:password)
      User.new({:email => "example2@example.com", :password => 'Password1'}).should have(1).error_on(:username)
      User.new({:username => 'Example', :email => "example2@example.com", :password => 'Password1'}).should have(0).errors
  end

  it "should ensure username and email are unique" do
      User.create!(
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
    user = User.create!(:username => "Example", :email => "example@example.com", :password => "Password1")
    todo = Todo.create!(:description => "A New Todo")
    user.todos << todo
    user.save
    user = User.find_by_id user.id
    user.todos.should == [todo]
  end

  it ".active_todos should return non-completed todos" do
    user = User.create!(:username => "Example", :email => "example@example.com", :password => "Password1")
    todo = Todo.create!(:description => "A New Todo")
    user.todos << todo
    todo2 = Todo.create!(:description => "A New Todo 2")
    todo2.complete
    todo2.save
    user.todos << todo2
    user.save
    user = User.find_by_id user.id
    user.todos.should == [todo, todo2]
    user.active_todos.should == [todo]
  end


end
