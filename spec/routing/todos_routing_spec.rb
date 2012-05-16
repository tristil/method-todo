require 'spec_helper'

describe "routing for todos" do
  it "should route /todos to todos controller" do
    { :get  => "/todos" }.should route_to :controller => 'todos', :action => 'index'
    { :get  => "/todos/completed" }.should route_to :controller => 'todos', :action => 'completed'
    { :post => "/todos" }.should route_to :controller => 'todos', :action => 'create'
    { :put => "/todos/1/complete" }.should route_to :controller => 'todos', :action => 'complete', :id => "1"
  end
end
