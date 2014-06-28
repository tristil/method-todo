require 'spec_helper'

describe TodoContext do
  it 'should require name' do
    TodoContext.new.should have(1).error_on :name
  end

  it '.to_json should use .as_json' do
    todo_context = TodoContext.create(name: 'Context')
    ActiveSupport::JSON.decode(todo_context.to_json)
      .should eq('id' => 1, 'name' => 'Context')
  end
end
