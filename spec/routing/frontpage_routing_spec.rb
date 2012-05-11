require 'spec_helper'

describe "routing for frontpage" do
  it "should route / to frontpage controller" do
    { :get => "/" }.should route_to :controller => 'frontpage', :action => 'index'
  end
end
