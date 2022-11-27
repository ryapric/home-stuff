Vagrant.configure("2") do |config|
  box = "debian/bullseye64"

  config.vm.provider "virtualbox" do |vb|
    vb.cpus   = 1
    vb.memory = 1024
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  config.vm.define "homestuff" do |hs|
    hs.vm.box = box
    hs.vm.network "forwarded_port", guest: 19132, host: 19132, protocol: "udp"
    hs.vm.synced_folder ".", "/vagrant" #, disabled: true

    hs.vm.provision "shell",
      inline: <<-SCRIPT
        bash /tmp/config/scripts/main.sh vagrant
      SCRIPT
  end
end
