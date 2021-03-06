worker_processes 10

pid    '/var/run/app/unicorn.pid'
listen '/var/run/app/rails.sock', backlog: 1024

log_path = '/var/www/puma-vs-unicorn/sample_app/log/unicorn.log'
stderr_path log_path
stdout_path log_path

timeout 30

preload_app true

before_fork do |_server, _worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |_server, _worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end