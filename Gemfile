source 'https://rubygems.org'

gem 'rails', '~> 4.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
gem 'devise'
gem 'paranoia'
gem 'mysql2'
gem 'timezone'
gem 'jquery-rails'
gem 'backbone-on-rails'
gem "raindrops"
gem 'dotenv-rails'

gem 'ejs'
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', :platform => :ruby
gem 'uglifier'

group :guard do
  gem 'rb-fsevent'
  gem 'libnotify'
  gem 'guard'
  gem 'guard-rails'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-konacha'
end

group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'cucumber'
  gem 'cucumber-rails', require: false
  gem 'selenium-webdriver'
  gem 'headless'
  gem 'timecop'
end

group :test, :development do
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-remote'
  gem "konacha"
  gem 'capybara-webkit'
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
group :deployment do
  gem 'unicorn'
  gem 'capistrano'
  gem 'capistrano3-unicorn'
  gem 'capistrano-rbenv'
  gem 'capistrano-rails'
end
