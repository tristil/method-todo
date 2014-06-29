require 'acceptance/spec_helper'

feature 'Filter todos', js: true do
  scenario 'todos are filtered by dropdown selection' do
    user = create_user
    visit root_path
    log_in_as_user(user)
    create_todo(description: 'Buy groceries +quiche @store #shopping')
    create_todo(description: 'Write report +project @work #reports')

    # Filter by contexts only
    select_dropdown_item(type: :context, label: '@store')
    should_see_todos('Buy groceries +quiche @store #shopping')
    should_see_dropdown_selections(context: '@store')
    should_see_filter_header('Active @store')

    select_dropdown_item(type: :context, label: '@work')
    should_see_todos('Write report +project @work #reports')
    should_see_dropdown_selections(context: '@work')
    should_see_filter_header('Active @work')

    click_all_todos_button

    # Filter by projects only
    select_dropdown_item(type: :project, label: '+quiche')
    should_see_todos('Buy groceries +quiche @store #shopping')
    should_see_dropdown_selections(project: '+quiche')
    should_see_filter_header('Active +quiche')

    select_dropdown_item(type: :project, label: '+project')
    should_see_todos('Write report +project @work #reports')
    should_see_dropdown_selections(project: '+project')
    should_see_filter_header('Active +project')

    click_all_todos_button

    # Filter by tags only
    select_dropdown_item(type: :tag, label: '#shopping')
    should_see_todos('Buy groceries +quiche @store #shopping')
    should_see_dropdown_selections(tag: '#shopping')
    should_see_filter_header('Active #shopping')

    select_dropdown_item(type: :tag, label: '#reports')
    should_see_todos('Write report +project @work #reports')
    should_see_dropdown_selections(tag: '#reports')
    should_see_filter_header('Active #reports')

    # Filter by all together
    select_dropdown_item(type: :context, label: '@store')
    select_dropdown_item(type: :tag, label: '#shopping')
    select_dropdown_item(type: :project, label: '+quiche')
    should_see_todos('Buy groceries +quiche @store #shopping')
    should_see_dropdown_selections(tag: '#shopping',
                                   context: '@store',
                                   project: '+quiche')
    should_see_filter_header('Active @store, +quiche, #shopping')

    select_dropdown_item(type: :context, label: '@work')
    todos_table_should_be_empty
    select_dropdown_item(type: :project, label: '+project')
    todos_table_should_be_empty
    select_dropdown_item(type: :tag, label: '#reports')
    should_see_todos('Write report +project @work #reports')
    should_see_filter_header('Active @work, +project, #reports')

    # Clear selections by clicking 'All'
    click_all_todos_button
    should_see_no_dropdown_selection
    should_see_filter_header('Active')
    should_see_todos('Write report +project @work #reports',
                     'Buy groceries +quiche @store #shopping')
  end
end
