# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "mlinvoice"
  config.vm.provider :virtualbox do |vb|
      vb.name = "MLInvoice"
  end

  config.vm.box = "ubuntu/focal64"

  config.vm.network "forwarded_port", guest: 80, host: 8888, host_ip: "127.0.0.1"

  config.vm.synced_folder "data/", "/data",
    owner: "root", group: "root", create: true, :mount_options => ["dmode=777","fmode=666"]

  config.vm.provision :shell, path: "bootstrap.sh"
end
