source 'https://rubygems.org'

gem 'rails', '~> 3.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
gem 'devise'
gem 'rails3_acts_as_paranoid'
gem 'mysql2'
gem 'timezone'
gem 'jquery-rails'
gem 'backbone-on-rails'
gem "raindrops", "~> 0.10.0"
gem "rails_config"

group :guard do
  gem 'rb-fsevent'
  gem 'libnotify'
  gem 'guard'
  gem 'guard-rails'
  gem 'guard-rails-assets'
  gem 'guard-bundler'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-jasmine-headless-webkit'
end

group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'cucumber'
  gem 'cucumber-rails', require: false
  gem 'capybara-webkit'
  gem 'headless'
  gem 'timecop'
  gem 'rspec-mocks'
  gem 'spork'
  gem 'jasmine'
  gem 'jasmine-spec-extras'
  gem 'jasmine-headless-webkit'
end

group :test, :development do
  gem 'debugger'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'bootstrap-sass'
  gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
group :deployment do
  gem 'unicorn'
  gem 'capistrano'
  gem 'rvm-capistrano'
  gem 'capistrano-unicorn'
  gem 'capistrano-rvm'
end

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
