module UsersHelper
  def create_and_login_user
    user = User.create(
      :username => 'Example',
      :email => 'example@example.com',
      :password => 'Password1',
      :password_confirmation => 'Password1'
    )
    sign_in user
    user
  end
end

