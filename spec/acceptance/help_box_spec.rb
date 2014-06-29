require 'acceptance/spec_helper'

feature 'Show help', js: true do
  scenario 'It toggles on and off' do
    user = create_user
    visit root_path
    log_in_as_user(user)
    should_see_help_text

    close_help_link
    should_not_see_help_text
    visit root_path
    should_not_see_help_text

    click_help_link
    should_see_help_text
    visit root_path
    should_see_help_text
  end
end
