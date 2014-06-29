require 'acceptance/spec_helper'

feature 'Edit a todo', js: true do
  scenario 'Edit a todo' do
    user = create_user
    visit root_path
    log_in_as_user(user)

    # Create a new todo
    todo = create_todo(description: 'A new todo +project @context #tag')
    should_see_todos('A new todo +project @context #tag')
    should_see_dropdown_items(context: ['@context'],
                              project: ['+project'],
                              tag: ['#tag'])

    edit_todo(todo.id, 'Another todo +project2 @context2 #tag2')
    should_see_todos('Another todo +project2 @context2 #tag2')

    # TODO: it would be nice to change this behavior
    should_see_dropdown_items(context: ['@context', '@context2'],
                              project: ['+project', '+project2'],
                              tag: ['#tag', '#tag2'])

    visit root_path
    should_see_todos('Another todo +project2 @context2 #tag2')
  end
end
