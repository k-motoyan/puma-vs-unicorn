pidfile    '/var/run/app/puma.pid'
state_path '/var/run/app/puma.state'

bind 'unix:///var/run/app/puma.sock'

worker_timeout 30

workers 2
threads 4, 16

preload_app!

before_fork do
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection_pool.disconnect!
end

on_worker_boot do
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end