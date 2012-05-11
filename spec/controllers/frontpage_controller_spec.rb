require 'spec_helper'

describe FrontpageController do
  it "should display 'log in/ sign up' on first arrival" do
    get :index
    page.should =~ /Login/
  end
end
