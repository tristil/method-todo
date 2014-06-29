require 'acceptance/spec_helper'

feature 'Click on badges', js: true do
  scenario 'It filters the table' do
    user = create_user
    visit root_path
    log_in_as_user(user)
    create_todo(description: 'Buy groceries +quiche @store')
    create_todo(description: 'Write report +project @work')
    should_see_todos('Write report +project @work',
                     'Buy groceries +quiche @store')

    click_badge('@store')
    should_see_todos('Buy groceries +quiche @store')

    click_all_todos_button

    click_badge('+project')
    should_see_todos('Write report +project @work')
  end
end
