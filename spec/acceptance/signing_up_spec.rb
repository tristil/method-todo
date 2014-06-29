require 'acceptance/spec_helper'

feature 'Signing up', js: true do
  it 'allows for signing up' do
    visit root_path
    should_see_unauthenticated_alert
    should_be_on_login_page
    click_link 'Sign up'

    fill_in_signup_form(username: 'example',
                        email: 'email@example.com',
                        password: 'Password1',
                        password_confirmation: 'Password2')

    should_have_signup_errors
    should_not_be_logged_in

    fill_in_signup_form(username: 'example',
                        email: 'email@example.com',
                        password: 'Password1',
                        password_confirmation: 'Password1')

    should_be_logged_in
  end
end
