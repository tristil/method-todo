module Acceptance
  module Users
    def log_in_as_user(user, password: 'Password1')
      should_be_on_login_page
      click_link("login-link")
      fill_in('user[email]', with: user.email)
      fill_in('user[password]', with: password)
      click_button 'Sign in'
    end

    def create_user(**options)
      username = options.fetch(:username) { 'Example' }
      email = options.fetch(:email) { 'newuser@example.com' }
      password = options.fetch(:password) { 'Password1' }

      User.create!(username: username,
                   email: email,
                   password: password)
    end
  end
end
