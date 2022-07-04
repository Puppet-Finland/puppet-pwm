# -*- mode: ruby -*-

Vagrant.configure("2") do |config|

  config.vm.define "pwm" do |box|
    box.vm.box = "ubuntu/focal64"
    box.vm.box_version = "20220511.0.0"
    box.vm.hostname = 'pwm.vagrant.example.lan'
    box.vm.provider 'virtualbox' do |vb|
      vb.gui = false
      vb.memory = 1280
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--hpet", "on"]
    end
    box.vm.network "private_network", ip: "192.168.59.80"
    box.vm.provision "shell", path: "vagrant/common.sh"
    box.vm.provision "shell", inline: "/usr/bin/apt-get update"
    box.vm.provision "shell",
      inline: "/opt/puppetlabs/bin/puppet apply /vagrant/vagrant/hosts.pp --modulepath=/vagrant/modules",
      env: {  'FACTER_my_host': 'pwm.vagrant.example.lan',
              'FACTER_my_ip': '192.168.59.112' }
    box.vm.provision "shell",
      inline: "/opt/puppetlabs/bin/puppet apply /vagrant/vagrant/pwm.pp --modulepath=/vagrant/modules"
  end
end
