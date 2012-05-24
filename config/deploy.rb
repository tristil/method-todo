set :application, "method-todo"

set :repository,  "git://github.com/tristil/method-todo.git"
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
set :deploy_to, "~/production-sites/method-todo"
set :deploy_via, :remote_cache

require 'rvm/capistrano'
require 'bundler/capistrano'

# Do backup
task :backup do
  filename = "methodtodo.sql"
  run "mysqldump -u root methodgtd > /tmp/#{filename}"
end

before "deploy:migrate", "backup"

after "deploy:update", "deploy:cleanup"
after "deploy:update", "deploy:migrate"

require 'capistrano-unicorn'
