require 'spec_helper'

describe FrontpageController do
  render_views

  it "should display site name and 'log in/ sign up' on first arrival" do
    get :index
    body = response.body
    body.should =~ /Method GTD/
    body.should =~ /Login/
    body.should =~ /Signup/
  end

  it "should display links to /accounts and Logout when logged in" do
    user = create_and_login_user
    get :index
    response.body.should =~ /Account/
    response.body.should =~ /Logout/
  end
end
