require 'spec_helper'

describe TodoContext do
  it "should require name" do
    TodoContext.new().should have(1).error_on :name
  end
end
