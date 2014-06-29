module Acceptance
  module Authentication
    def should_see_unauthenticated_alert
      should_see_error_alert(
        'You need to sign in or sign up before continuing.')
    end

    def should_see_invalid_credentials_alert
      should_see_error_alert('Invalid email or password.')
    end

    def should_not_be_logged_in
      page.should_not have_content 'Welcome, '
    end

    def should_be_logged_in
      page.should have_content('Account')
    end

    def should_have_signup_errors
      page.should have_css('#error_explanation')
    end

    def fill_in_signup_form(username:,
                            email:,
                            password:,
                            password_confirmation:)
      password_confirmation ||= password
      fill_in('user[email]', with: email)
      fill_in('user[username]', with: username)
      fill_in('user[password]', with: password)
      fill_in('user[password_confirmation]', with: password_confirmation)
      click_button('Sign up')
    end

    def log_in_as_user(user, password: 'Password1')
      should_be_on_login_page
      click_link('login-link')
      fill_in('user[email]', with: user.email)
      fill_in('user[password]', with: password)
      click_button 'Sign in'
    end
  end
end
