# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
#Valheim server machine
	config.vm.define "srv-val" do |config|
	config.vm.box = "ubuntu/xenial64"
	config.vm.network "public_network", ip: "192.168.0.50", mac: "080027353062", use_dhcp_assigned_default_route: true
	config.vm.provider :virtualbox do |v|
		v.customize ["modifyvm", :id, "--name", "srv-val"]
		v.customize ["modifyvm", :id, "--groups", "/Servers"]
		v.customize ["modifyvm", :id, "--cpus", "4"]
		v.customize ["modifyvm", :id, "--memory", 8192]
		v.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
		v.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
	end
	config.vm.provision "shell", path: "scripts/valheim_install_server.sh"
	config.vm.provision "shell", path: "scripts/valheim_backup_automation.sh"
	config.vm.provision "shell", path: "scripts/valheim_start.sh"
end
end
