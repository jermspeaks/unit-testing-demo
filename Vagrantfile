# -*- mode: ruby -*-
# vi: set ft=ruby :

# change the values here to your preference, though the defaults
# should work just fine...
IP_TO_USE = '192.168.0.65'
DOMAIN_NAME = 'unittestdemo.dev'

# exit if vagrant-dns plugin isn't installed
unless Vagrant.has_plugin?("vagrant-dns")
  raise <<-eos

Error! Required 'vagrant-dns' plugin is not installed.
Please run 'vagrant plugin install vagrant-dns'
eos
end

Vagrant.configure(2) do |config|
  config.vm.box = "precise32"
  config.vm.hostname = "#{DOMAIN_NAME}"

  ## use ubuntu precise 32-bit
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  ## add the current directory as a sync'd folder mounted at /vagrant
  config.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777", "fmode=666"]

  ## setup IP address and ssh forwarding
  config.vm.network :private_network, ip: "#{IP_TO_USE}"
  config.ssh.forward_agent = true

  ## provisioners
  config.vm.provision :shell, :path => "root-install.sh", privileged: true, keep_color: true
  config.vm.provision :shell, :path => "user-install.sh", privileged: false, keep_color: true

  ## virtualbox settings
  config.vm.provider :virtualbox do |vb|
    vb.gui  = false
    vb.name = 'unittestdemo'
  end

  ## dns settings
  config.dns.tlds = ['dev']
  config.dns.patterns = [/^.*#{DOMAIN_NAME}$/]
end
