require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the TodoHelper. For example:
#
# describe TodoHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe TodoHelper do
  it "should parse a bare description string" do
    helper.parse_todo_description("Write report").should == 'Write report'
  end

  it "should parse a description string with +project" do
    helper.parse_todo_description("Write first draft +report").should == "Write first draft <span class='label'>+report</span>"
  end

  it "should parse a description string with @context" do
    helper.parse_todo_description("Write report @home").should == "Write report <span class='label'>@home</span>"
  end

  it "should parse a description string with @context and +project" do
    helper.parse_todo_description("Write first draft +report @home").should == "Write first draft <span class='label'>+report</span> <span class='label'>@home</span>"
  end


end
