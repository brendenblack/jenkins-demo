# -*- mode: ruby -*-
# vi: set ft=ruby :


$scriptsWithSudo = <<SCRIPT
  sudo timedatectl set-timezone America/Vancouver
  sudo rpm -iUvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  sudo yum -y update
  sudo yum -y install kernel* dkms gcc ansible gcc python-pip python-devel openssl-devel unzip git wget ImageMagick ssmtp
  sudo pip install "pywinrm>=0.1.1"
  sudo yum remove java
  sudo yum -y install java-1.8.0-openjdk
  sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
  sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
  sudo yum -y install jenkins
  sudo systemctl stop postfix
  sudo systemctl disable postfix
  sudo alternatives --set mta /usr/sbin/sendmail.ssmtp
  echo 'Generating private/public key pair'
  sudo -Hu vagrant ssh-keygen -q -f /home/vagrant/.ssh/id_rsa -t rsa -N ''
  sudo -Hu vagrant cp /home/vagrant/.ssh/id_rsa /home/vagrant/ansible_private_key
  sudo -Hu vagrant cp /home/vagrant/.ssh/id_rsa.pub /home/vagrant/ansible_public_key
  chown vagrant:vagrant /home/vagrant/ansible_private_key
  sudo -Hu vagrant chmod go= /home/vagrant/ansible_private_key
  sudo -Hu vagrant bash -c 'cat /home/vagrant/ansible_public_key >> /home/vagrant/.ssh/authorized_keys'
  sudo -Hu vagrant ln -fs /vagrant/files/util/vagrant/vagrant.bash_profile /home/vagrant/.bash_profile
  sudo sed -i -- 's/PasswordAuthentication no/#PasswordAuthentication no/g' /etc/ssh/sshd_config
  sudo sed -i -- 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
  sudo systemctl restart sshd
  sudo -i echo 'wwwadm  ALL=(ALL:ALL) ALL' >> /etc/sudoers

SCRIPT

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "centos/7"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 8023, host: 8023, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 22, host: 2223, id: 'ssh'
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  config.vm.provision "shell", inline: $scriptsWithSudo
  config.vm.provision "shell", inline: "sudo rm /etc/localtime && sudo ln -s /usr/share/zoneinfo/Canada/Pacific /etc/localtime", run: "always"
end
