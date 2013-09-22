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
role :db, host, :primary => true # This is where Rails migrations will run

ssh_options[:forward_agent] = true
ssh_options[:keys] = %w('~/.ssh/id_rsa.pub')
default_run_options[:pty] = true

set :default_environment, {
  'PATH' => '/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH'
}

set :use_sudo, false
set :deploy_to, "/home/#{user}/production-sites/method-todo"
set :deploy_via, :remote_cache

require 'bundler/capistrano'

# Do backup
task :backup do
  filename = "methodtodo.sql"
  run "mysqldump -u root methodgtd > /tmp/#{filename}"
end

task :set_credentials do
  # Taken from https://github.com/digineo/secret_token_replacer
  release_settings = "#{release_path}/config/settings.yml"
  shared_settings  = "#{shared_path}/config/settings.yml"

  if capture("[ -f #{shared_settings} ] || echo missing").start_with?('missing')
    run "mkdir -p #{shared_path}/config"
    upload("#{File.expand_path(File.dirname(__FILE__))}/settings.yml",
            shared_settings)
  end

  run "ln -nfs #{shared_settings} #{release_settings}"
end

before "deploy:migrate", "backup"

after "deploy:update", "deploy:cleanup"
after "deploy:update", "deploy:migrate"
before "deploy:finalize_update", "set_credentials"

require 'capistrano-unicorn'

after 'deploy:restart', 'unicorn:restart'
