require 'spec_helper'

describe Todo do
  it "should require a description" do
    Todo.new.should have(1).error_on(:description)
  end

  it ".user should return user" do
    user = User.create!(:username => "Example", :email => "example@example.com", :password => "Password1")
    todo = Todo.create!(:description => "A New Todo")
    todo.user = user
    todo.save
    todo = Todo.find_by_id todo.id
    todo.user.should == user
  end

  it ".complete should mark record as completed and set completed time" do
    todo = Todo.create!(:description => "A New Todo")
    todo.complete
    todo.save
    todo.reload
    todo.completed.should be_true
  end
end
