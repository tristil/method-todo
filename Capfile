require 'capistrano/setup'
require 'capistrano/deploy'

require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/migrations'
require 'capistrano/rails/assets'
require 'capistrano3/unicorn'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
