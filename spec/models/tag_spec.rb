require 'spec_helper'

describe Project do
  it "should require name" do
    Tag.new.should have(1).error_on :name
  end
end
