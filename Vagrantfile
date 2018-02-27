# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "pwm" do |box|
    box.vm.box = "ubuntu/xenial64"
    box.vm.box_version = "20171118.0.0"
    box.vm.hostname = "pwm.local"
    box.vm.network "private_network", ip: "192.168.103.100"
    box.vm.network "forwarded_port", guest: 8080, host: 18080
    box.vm.synced_folder ".", "/vagrant", type: "virtualbox"
    box.vm.provision "shell" do |s|
      s.path = "vagrant/prepare.sh"
      s.args = ["-n", "pwm", "-f", "debian", "-o", "xenial", "-b", "/home/ubuntu"]
    end
    box.vm.provision "shell", inline: "puppet apply --modulepath /home/ubuntu/modules /vagrant/vagrant/pwm.pp"
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 1534
    end
  end

  config.vm.define "pwm-dirsrv" do |box|
    box.vm.box = "centos/7"
    box.vm.box_version = "1710.01"
    box.vm.hostname = "pwm-dirsrv.local"
    box.vm.network "private_network", ip: "192.168.103.101"
    box.vm.network "forwarded_port", guest: 9830, host: 19830
    box.vm.network "forwarded_port", guest: 389, host: 10389
    box.vm.synced_folder ".", "/vagrant", type: "virtualbox"
    box.vm.provision "shell" do |s|
      s.path = "vagrant/prepare.sh"
      s.args = ["-n", "pwm", "-f", "redhat", "-o", "el-7", "-b", "/home/vagrant"]
    end
    box.vm.provision "shell", inline: "puppet apply --modulepath /home/vagrant/modules /vagrant/vagrant/dirsrv.pp"
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 1024
    end
  end
end
