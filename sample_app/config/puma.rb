pidfile    '/home/vagrant/tmp/puma.pid'
state_path '/home/vagrant/tmp/puma.state'

bind 'unix:///home/vagrant/run/puma.sock'

worker_timeout 30

workers 2
threads 4, 16

preload_app!

on_worker_boot do
  ActiveRecord::Base.establish_connection
end