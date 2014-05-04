module Acceptance
  module Alerts
    def should_see_error_alert(message)
      should_see_alert(message, type: 'danger')
    end

    def should_see_alert(message, type: 'info')
      page.should have_css(".alert.alert-#{type}", text: message)
    end
  end
end
