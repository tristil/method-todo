require 'spec_helper'

describe "routing for todos" do
  it "should route /todos to todos controller" do
    { :get  => "/todos" }.should route_to :controller => 'todos', :action => 'index'
    { :post => "/todos" }.should route_to :controller => 'todos', :action => 'create'
    { :put => "/todos/1/complete" }.should route_to :controller => 'todos', :action => 'complete', :id => "1"
  end

  it "should route /contexts to todo_contexts controller" do
    { :get  => "/contexts" }.should route_to :controller => 'todo_contexts', :action => 'index'
    { :post => "/contexts" }.should route_to :controller => 'todo_contexts', :action => 'create'
  end

    it "should route /projects to projects controller" do
    { :get  => "/projects" }.should route_to :controller => 'projects', :action => 'index'
    { :post => "/projects" }.should route_to :controller => 'projects', :action => 'create'
  end


end
