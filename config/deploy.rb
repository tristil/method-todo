set :application, "method-gtd"

set :repository,  "git://github.com/tristil/method-gtd.git"
set :scm, :git

server = Capistrano::CLI.ui.ask "SSH server: "
set(:user) { Capistrano::CLI.ui.ask "SSH username: " }
set(:password) { Capistrano::CLI.ui.ask "SSH password: " }

role :web, server                          # Your HTTP server, Apache/etc
role :app, server                          # This may be the same as your `Web` server
role :db,  server, :primary => true # This is where Rails migrations will run

ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :use_sudo, false
set :deploy_to, "~/production-sites/method-gtd"
set :deploy_via, :remote_cache

require 'rvm/capistrano'
require 'capistrano-unicorn'
require 'bundler/capistrano'
