set :application, "method-todo"

set :repository,  "git://github.com/tristil/method-todo.git"
set :scm, :git

server = Capistrano::CLI.ui.ask "SSH server: "
set(:user) { Capistrano::CLI.ui.ask "SSH username: " }

role :web, server                          # Your HTTP server, Apache/etc
role :app, server                          # This may be the same as your `Web` server
role :db,  server, :primary => true # This is where Rails migrations will run

ssh_options[:forward_agent] = true
ssh_options[:keys] = %w('~/.ssh/id_rsa.pub')
default_run_options[:pty] = true

set :use_sudo, false
set :deploy_to, "/home/#{user}/production-sites/method-todo"
set :deploy_via, :remote_cache

require 'rvm/capistrano'
require 'bundler/capistrano'

# Do backup
task :backup do
  filename = "methodtodo.sql"
  run "mysqldump -u root methodgtd > /tmp/#{filename}"
end

task :set_credentials do
  upload("#{File.expand_path(File.dirname(__FILE__))}/credentials.yml",
         "#{current_path}/config/credentials.yml")
end

before "deploy:migrate", "backup"

after "deploy:update", "deploy:cleanup"
after "deploy:update", "deploy:migrate"
after "deploy:update", "set_credentials"

require 'capistrano-unicorn'

after 'deploy:restart', 'unicorn:restart'
