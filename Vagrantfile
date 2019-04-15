# _*_ mode: ruby _*_
# vi: set ft=ruby :

hostip = "127.1"
vagrant_root = File.dirname(__FILE__)

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.synced_folder vagrant_root + "/application", "/mnt/application"
  config.vm.synced_folder vagrant_root + "/config", "/mnt/config"
  config.vm.network "forwarded_port", guest: 80, host:8000, auto_correct: true, host_ip: hostip
  config.vm.provision "shell", inline: "sudo bash -x /mnt/config/setup.sh"

end


