# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'method-todo'
set :repo_url, 'git://github.com/tristil/method-todo.git'

set :linked_files, %w{.env}
set :linked_dirs, %w{bin log tmp vendor/bundle public/system}

set :deploy_to, "/home/#{ENV["DEPLOY_USER"]}/production-sites/method-todo"
set :rails_env, :production
set :rbenv_type, :system
set :rbenv_ruby, File.read('.ruby-version').strip

# Default value for :pty is false
# set :pty, true

#set :default_env, {
  #'PATH' => '/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH'
#}
#

# Do backup
task :backup do
  on roles(:all) do
    execute "mysqldump", "-u", "root", "methodgtd", ">", "/tmp/methodtodo.sql"
  end
end

namespace :deploy do
  after 'publishing', 'deploy:restart'
  task :restart do
    invoke 'unicorn:restart'
  end
  before :starting, :make_folders do
    on roles(:all) do
      execute "mkdir", "-p", "#{shared_path}/tmp/pids"
      execute "mkdir", "-p", "#{shared_path}/tmp/sockets"
    end
  end
  before :starting, :backup
  before :starting, :upload_env do
    on roles(:all) do
      upload! ".env", "#{shared_path}/.env"
    end
  end
end
