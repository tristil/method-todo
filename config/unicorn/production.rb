app_path = File.expand_path(File.dirname(__FILE__) + '/../../')

worker_processes 3
preload_app true
timeout 180

working_directory app_path

stderr_path 'log/unicorn.log'
stdout_path 'log/unicorn.log'

pid "#{app_path}/tmp/pids/unicorn.pid"
listen "#{app_path}/tmp/sockets/unicorn.sock", backlog: 64

before_fork do |server, _worker|
  ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH => e
      e
      # someone else did our job for us
    end
  end
end

after_fork do |_server, _worker|
  ActiveRecord::Base.establish_connection
end
