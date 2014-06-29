require 'acceptance/spec_helper'

feature 'Add a todo', js: true do
  scenario 'Creating a todo' do
    user = create_user
    visit root_path
    log_in_as_user(user)

    # Create a new todo
    create_todo(description: 'A new todo')
    should_see_todos('A new todo')

    # Raises alert if description is empty
    enter_todo(description: '')
    accept_dialog

    # Create a todo with a context
    enter_todo(description: 'Write report @work')
    should_see_todos('Write report @work', 'A new todo')
    should_see_dropdown_items(context: ['@work'])
    todo_input_should_be_focused
    todo_input_should_be_cleared

    # Create a todo with a project
    create_todo(description: 'Read book +bigreport')
    should_see_dropdown_items(context: ['@work'],
                              project: ['+bigreport'])
    should_see_todos('Read book +bigreport',
                     'Write report @work',
                     'A new todo')

    # Create a todo with a tag
    create_todo(description: 'Buy pencil #purchase')
    should_see_dropdown_items(tag: ['#purchase'],
                              context: ['@work'],
                              project: ['+bigreport'])
    should_see_todos('Buy pencil #purchase',
                     'Read book +bigreport',
                     'Write report @work',
                     'A new todo')

    # Make sure effects took place on server
    visit root_path
    should_see_todos('Buy pencil #purchase',
                     'Read book +bigreport',
                     'Write report @work',
                     'A new todo')
  end
end
