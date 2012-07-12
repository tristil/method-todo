require 'spec_helper'

describe Project do
  it "should raise an error over mass-assignment" do
    expect do
      Tag.new(:user_id => 2)
    end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end

  it "should require name" do
    Tag.new.should have(1).error_on :name
  end
end
