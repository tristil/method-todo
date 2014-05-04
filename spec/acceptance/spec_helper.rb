require 'spec_helper'
require 'capybara/rspec'

Dir[Rails.root.join("spec/acceptance/support/**/*.rb")].each {|f| require f}
RSpec.configure do |config|
  Acceptance.constants.each { |m| config.include(Acceptance.const_get(m)) }
end
