require 'spec_helper'

describe FrontpageController do
  render_views

  it "should display site name and 'log in/ sign up' on first arrival" do
    get :index
    response.should be_redirect
  end

  it "should display links to /accounts and Logout when logged in" do
    user = create_and_login_user
    get :index
    response.body.should =~ /Account/
    response.body.should =~ /Logout/
  end

  it "should display active todos" do
    user = create_and_login_user
    todo = Todo.create(:description => "A New Todo")
    user.todos << todo
    todo2 = Todo.create(:description => "A New Todo 2")
    todo2.complete
    todo2.save
    user.todos << todo2
    user.save
    get :index
    response.body.should =~ /A New Todo/

    # this has to be tested in integeration I believe
    response.body.should =~ /A New Todo 2/
  end

  it "should not display help-box if user preference is set" do
    user = create_and_login_user
    user.preferences[:show_help] = false
    user.save
    get :index
    response.body.should =~ /<div id='help-box' class='well' style='display:none'>/
    response.body.should =~ /<a id='show-help-box' href='#' style='float: right;'>/
  end
end
