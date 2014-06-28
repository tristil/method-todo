require 'spec_helper'

describe TagsController do
  it 'should redirect to / if user is not logged in' do
    get :index
    response.should be_redirect
  end

  it 'should show contexts for todos' do
    user = create_and_login_user
    todo = Todo.create(description: 'A New Todo')
    tag = Tag.create(name: 'work')
    tag.user = user
    tag.save
    todo.tags << tag
    get :index
    ActiveSupport::JSON.decode(response.body)
      .should == [{ 'id' => 1, 'name' => 'work' }]
  end

  it 'should delete tags from all todos' do
    user = create_and_login_user
    todo = Todo.create(description: 'Buy milk #purchase')
    todo.user = user
    todo.parse
    todo.save
    delete :destroy, id: 1
    todo.reload
    todo.tags.should be_empty
    todo.description.should == 'Buy milk'
  end

end
