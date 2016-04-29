pidfile    '/var/run/app/puma.pid'
state_path '/var/run/app/puma.state'

bind 'unix:///var/run/app/rails.sock'

log_path = '/var/www/puma-vs-unicorn/sample_app/log/puma.log'
stdout_redirect log_path, log_path, true

worker_timeout 30

workers 2
threads 40, 40

preload_app!

before_fork do
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection_pool.disconnect!
end

on_worker_boot do
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end