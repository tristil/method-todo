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

describe FrontpageController, "#timezone" do
  before(:each) do
    @user = create_and_login_user
    @latitude, @longitude = "30.2450952", "-100.9347053"

    require 'ostruct'
    timezone = OpenStruct.new
    timezone.utc_offset = -18000;
    # Don't make a call against the geoname service
    Timezone::Zone.stub(:new) { timezone }

    # This is diabled if the user hasn't changed the default value
    MethodTodo::Application.config.perform_geoname_lookups = true
  end

  it "should set timezone preference when lat and lon are passed" do
    post :set_timezone, :latitude => @latitude, :longitude => @longitude
    data = ActiveSupport::JSON.decode(response.body)
    data["offset"].should == -5
    @user.reload
    @user.preferences[:timezone_offset].should == -5
  end

  it "should set timezone preference when offset is passed" do
    post :set_timezone, :offset => "5"
    data = ActiveSupport::JSON.decode(response.body)
    data["offset"].should == -5
    @user.reload
    @user.preferences[:timezone_offset].should == -5
  end

  it "should use offset value when geoname is disabled" do
    # If the geoname username hasn't been set it should use the offset value
    # and not call geoname
    Timezone::Zone.should_not_receive :new
    MethodTodo::Application.config.perform_geoname_lookups = false
    post :set_timezone, :latitude => @latitude, :longitude => @longitude, :offset => "5"
    data = ActiveSupport::JSON.decode(response.body)
    data["offset"].should == -5
    @user.reload
    @user.preferences[:timezone_offset].should == -5
  end
end
