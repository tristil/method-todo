require 'spec_helper'

describe TagsController do
  it "should redirect to / if user is not logged in" do
    get :index
    response.should be_redirect
  end

  it "should show contexts for todos" do
    user = create_and_login_user
    todo = Todo.new(:description => 'A New Todo')
    tag = Tag.create(:name => 'work')
    tag.user = user
    tag.save
    todo.tags << tag
    user.tags << tag
    user.save
    get :index
    ActiveSupport::JSON.decode(response.body).should == [{"id" => 1, "name" => 'work'}]
  end
end
