VAGRANTFILE_API_VERSION = "2"

# Bootstrap installing necessary packages and convert shell scripts to Unix
$bootstrap_ubuntu = <<SCRIPT
apt-get -y update
apt-get -y upgrade
apt-get -y install openvswitch-common openvswitch-switch dos2unix
systemctl enable openvswitch-switch
systemctl start openvswitch-switch
systemctl status openvswitch-switch
localectl set-keymap de
loadkeys de
cd /docker-sfc && dos2unix *.sh && chmod u+x *.sh
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.provision "docker"
  config.vm.synced_folder ".", "/docker-sfc"

  config.vm.define "docker-sfc-vm1" do | vm1 |
    vm1.vm.host_name = "docker-sfc-vm1"
	vm1.vm.network :private_network, ip: "192.168.56.21"
    vm1.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 2096]
      v.customize ["modifyvm", :id, "--cpus", 2]
    end
    vm1.vm.provision "shell", inline: $bootstrap_ubuntu
    vm1.vm.provision "shell", privileged: true, inline: "cd /docker-sfc && ./magicIsAboutToHappenVM1.sh"
  end

  config.vm.define "docker-sfc-vm2" do | vm2 |
    vm2.vm.host_name = "docker-sfc-vm2"
	vm2.vm.network :private_network, ip: "192.168.56.22"
    vm2.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 2096]
      v.customize ["modifyvm", :id, "--cpus", 2]
    end
    vm2.vm.provision "shell", inline: $bootstrap_ubuntu
    vm2.vm.provision "shell", privileged: true, inline: "cd /docker-sfc && ./magicIsAboutToHappenVM2.sh"
  end
end