Vagrant.configure("2") do |config|
  box = "debian/bullseye64"

  config.vm.provider "virtualbox" do |vb|
    vb.cpus   = 2
    vb.memory = 1024
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  config.vm.define "homestuff" do |hs|
    hs.vm.box = box

    hs.vm.network "forwarded_port", guest: 53, host: 8053, protocol: "tcp" # Pi-Hole DNS
    hs.vm.network "forwarded_port", guest: 53, host: 8053, protocol: "udp" # Pi-Hole DNS
    hs.vm.network "forwarded_port", guest: 80, host: 8080, protocol: "tcp" # Pi-Hole web console

    hs.vm.synced_folder ".", "/vagrant" #, disabled: true

    hs.vm.provision "shell",
      inline: <<-SCRIPT
        bash /vagrant/config/scripts/main.sh vagrant
      SCRIPT
  end
end
