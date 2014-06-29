require 'acceptance/spec_helper'

feature 'Manage filters', js: true do
  scenario 'delete filters across todos' do
    user = create_user
    visit root_path
    log_in_as_user(user)
    create_todo(description: 'Buy groceries +quiche @store #shopping')
    create_todo(description: 'Write report +project @work #reports')

    # Delete a context filter
    open_manage_filter_dialog(:context)
    within_manage_filter_dialog do
      should_see_manage_filter_items('store', 'work')
      delete_filter('store')
      should_see_manage_filter_items('work')

      click_delete_filter('work')
      click_delete_filter_cancel_button
      should_see_manage_filter_items('work')
      close_manage_filter_dialog
    end

    should_see_todos('Write report +project @work #reports',
                     'Buy groceries +quiche #shopping')

    # Delete a project filter
    open_manage_filter_dialog(:project)
    within_manage_filter_dialog do
      delete_filter('project')
      should_see_manage_filter_items('quiche')
      close_manage_filter_dialog
    end

    should_see_todos('Write report @work #reports',
                     'Buy groceries +quiche #shopping')

    # Delete a tag filter
    # open_manage_filter_dialog(:tag)
    # within_manage_filter_dialog do
    # delete_filter('shopping')
    # should_see_manage_filter_items('reports')
    # close_manage_filter_dialog
    # end

    # should_see_todos('Write report @work #reports',
    # 'Buy groceries +quiche')
  end
end
