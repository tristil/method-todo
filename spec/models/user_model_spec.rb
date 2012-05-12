require 'spec_helper'

describe User do
  it "should require username, email and password" do
      User.new({:username => 'Example', :email => "example1@example.com"}).should have(1).error_on(:password)
      User.new({:email => "example2@example.com", :password => 'Password1'}).should have(1).error_on(:username)
      User.new({:username => 'Example', :email => "example2@example.com", :password => 'Password1'}).should have(0).errors
  end
end
