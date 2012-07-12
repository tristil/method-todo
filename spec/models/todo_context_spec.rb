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
end
