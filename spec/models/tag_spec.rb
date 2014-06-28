require 'spec_helper'

describe Project do
  it 'should raise an error over mass-assignment' do
    Tag.new(user_id: 2)
  end

  it 'should require name' do
    Tag.new.should have(1).error_on :name
  end

  it '.to_json should use .as_json' do
    tag = Tag.create(name: 'Tag')
    ActiveSupport::JSON.decode(tag.to_json)
      .should eq('id' => 1, 'name' => 'Tag')
  end

end
