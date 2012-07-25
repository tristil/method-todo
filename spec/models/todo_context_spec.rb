require 'spec_helper'

describe TodoContext do
  it "should raise an error over mass-assignment" do
    expect do
      TodoContext.new(:user_id => 2)
    end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end

  it "should require name" do
    TodoContext.new().should have(1).error_on :name
  end

  it ".to_json should use .as_json" do
    todo_context = TodoContext.create(:name => 'Context')
    ActiveSupport::JSON.decode(todo_context.to_json).should == {"id"=>1, "name" => "Context"}
  end

end
