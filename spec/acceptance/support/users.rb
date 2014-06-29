module Acceptance
  module Users
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
