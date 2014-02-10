source 'https://rubygems.org'

gem 'rails', '~> 3.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
gem 'devise'
gem 'acts_as_paranoid'
gem 'mysql2'
gem 'timezone'
gem 'jquery-rails'
gem 'backbone-on-rails'
gem "raindrops", "~> 0.10.0"
gem 'dotenv-rails'

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
  gem 'pry-debugger'
  gem "konacha", "~> 3.0.0"
  gem 'capybara-webkit'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'bootstrap-sass', '~> 2.3.2.2'
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
  gem 'capistrano', '~> 3.0'
  gem 'capistrano3-unicorn'
  gem 'capistrano-rbenv'
  gem 'capistrano-rails'
  gem 'turbo-sprockets-rails3'
end

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
