require 'spec_helper'

describe "routing for todos" do
  it "should route /todos to todos controller" do
    { :get  => "/todos" }.should route_to :controller => 'todos', :action => 'index'
    { :post => "/todos" }.should route_to :controller => 'todos', :action => 'create'
    { :put => "/todos/1/complete" }.should route_to :controller => 'todos', :action => 'complete', :id => "1"
    { :put => "/todos/1/toggle_tickler_status" }.should route_to :controller => 'todos', :action => 'toggle_tickler_status', :id => "1"
    { :get => "/todos/1" }.should route_to :controller => 'todos', :action => 'show', :id => "1"
    { :delete => "/todos/1" }.should route_to :controller => 'todos', :action => 'destroy', :id => "1"
  end

  it "should route /contexts to todo_contexts controller" do
    { :get  => "/contexts" }.should route_to :controller => 'todo_contexts', :action => 'index'
    { :post => "/contexts" }.should route_to :controller => 'todo_contexts', :action => 'create'
    { :delete => "/contexts/1" }.should route_to :controller => 'todo_contexts', :action => 'destroy', :id => "1"
  end

  it "should route /projects to projects controller" do
    { :get  => "/projects" }.should route_to :controller => 'projects', :action => 'index'
    { :post => "/projects" }.should route_to :controller => 'projects', :action => 'create'
    { :delete => "/projects/1" }.should route_to :controller => 'projects', :action => 'destroy', :id => "1"
  end

  it "should route /tags to tags controller" do
    { :get  => "/tags" }.should route_to :controller => 'tags', :action => 'index'
    { :post => "/tags" }.should route_to :controller => 'tags', :action => 'create'
    { :delete => "/tags/1" }.should route_to :controller => 'tags', :action => 'destroy', :id => "1"
  end

end
