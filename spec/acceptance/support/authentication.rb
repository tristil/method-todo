module Acceptance
  module Authentication
    def should_see_unauthenticated_alert
      should_see_error_alert('You need to sign in or sign up before continuing.')
    end

    def should_see_invalid_credentials_alert
      should_see_error_alert('Invalid email or password.')
    end
  end
end
