require 'acceptance/spec_helper'

feature 'Logging in', js: true do

  it 'allows for logging in with valid credentials' do
    user = create_user(username: 'Example', password: 'Password1')
    visit root_path
    should_see_unauthenticated_alert
    should_be_on_login_page

    # Try with wrong password
    log_in_as_user(user, password: 'Wrong')
    should_see_invalid_credentials_alert

    # Try with correct password
    log_in_as_user(user, password: 'Password1')
    should_be_on_main_todo_page
  end
end
