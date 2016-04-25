# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'
  config.vm.box = 'ubuntu14.04'

  config.vm.network "forwarded_port", guest: 8081, host: 8081
  config.vm.network "forwarded_port", guest: 8082, host: 8082
  config.vm.network "private_network", type: :dhcp

  config.vm.synced_folder './', '/vagrant', nfs: true

  config.vm.provider 'virtualbox' do |vb|
    vb.cpus = 2
    vb.memory = 4096
  end

  config.vm.provision 'ansible' do |ansible|
    ansible.playbook = 'server.yml'
  end
end
