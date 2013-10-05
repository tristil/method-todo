require 'bundler/capistrano'
require 'capistrano-unicorn'
# require 'sidekiq/capistrano'
require 'dotenv/capistrano'

set :default_environment, {
  'PATH' => '/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH'
}

set :application, "method-todo"

set :repository,  "git://github.com/tristil/method-todo.git"
set :scm, :git

if ENV["DEPLOY_SERVER"]
  set(:host) { ENV["DEPLOY_SERVER"] }
  set(:user) { ENV["DEPLOY_USER"] }
else
  set(:host) { Capistrano::CLI.ui.ask "SSH server: " }
  set(:user) { Capistrano::CLI.ui.ask "SSH username: " }
end

role :web, host # Your HTTP server, Apache/etc
role :app, host # This may be the same as your `Web` server
role :db,  host, :primary => true # This is where Rails migrations will run

ssh_options[:forward_agent] = true
ssh_options[:keys] = %w('~/.ssh/id_rsa.pub')
default_run_options[:pty] = true

set :use_sudo, false
set :deploy_to, "/home/#{user}/production-sites/method-todo"
set :deploy_via, :remote_cache
set :rails_env, :production

# Do backup
task :backup do
  run "mysqldump -u root methodgtd > /tmp/methodtodo.sql"
end

task :set_credentials do
  upload("#{File.expand_path(File.dirname(__FILE__))}/../.env",
         "#{shared_path}/.env")
end

namespace :unicorn do
  task :make_sockets_dir do
    run "mkdir -p #{shared_path}/sockets"
    run "ln -s #{shared_path}/sockets #{latest_release}/tmp/sockets"
  end
end

before "deploy:migrate", "backup"

after "deploy:update", "deploy:cleanup"
after "deploy:update", "deploy:migrate"
before "deploy:finalize_update", "set_credentials"

before 'deploy:start', 'unicorn:make_sockets_dir'
after 'deploy:start', 'unicorn:start'
after 'deploy:restart', 'unicorn:restart'
after 'deploy:reload', 'unicorn:reload'
after 'deploy:stop', 'unicorn:stop'
