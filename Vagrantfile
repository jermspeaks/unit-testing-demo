# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
IP_TO_USE = '192.168.0.65'
PORT_TO_USE = '8055'
DOMAIN_NAME = 'unittestdemo.dev'
SITE = 'unittestdemo'


unless Vagrant.has_plugin?("vagrant-hostmanager")
  raise 'Vagrant Host Manager plugin not installed. Please run "vagrant plugin install vagrant-hostmanager" from shell or visit https://github.com/smdahlen/vagrant-hostmanager for more information.'
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "precise32"
	config.ssh.forward_agent = true

    config.vm.box_url = "http://files.vagrantup.com/precise32.box"

    config.vm.network :forwarded_port, guest: 80, host: PORT_TO_USE

    config.vm.provision :shell, :path => "root-install.sh"
    config.vm.provision :shell, :path => "user-install.sh", privileged: false

    config.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777", "fmode=666"]
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
    config.vm.define SITE do |node|
        node.vm.hostname = DOMAIN_NAME
        node.vm.network :private_network, ip: IP_TO_USE
    end

    

end
