require 'spec_helper'

describe "routing for frontpage" do
  it "should route / to frontpage controller" do
    { :get => "/" }.should route_to :controller => 'frontpage', :action => 'index'
    { :get => "/toggle_help" }.should route_to :controller => 'frontpage', :action => 'toggle_help'
    { :post => "/timezone" }.should route_to :controller => 'frontpage', :action => 'set_timezone'
  end
end
