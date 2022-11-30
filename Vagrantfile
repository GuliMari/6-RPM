# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
	config.vm.box = "centos/7"
	config.vm.synced_folder ".", "/vagrant", disabled: true
	config.vm.boot_timeout = 3000
	config.vm.box_check_update = false
	config.vm.provider "virtualbox" do |v|
	  v.memory = 1024
	  v.cpus = 2
	end
	
	config.vm.define "repo" do |box|
	  box.vm.network "private_network", type: "dhcp"
	  box.vm.hostname = "repo"
	  box.vm.provision "shell", 
	  	path: "repo.sh"
	  box.vm.provision "shell", 
		inline: <<-SHELL
	    	mkdir -p ~root/.ssh
        	cp ~vagrant/.ssh/auth* ~root/.ssh
                SHELL
	end
  
end
