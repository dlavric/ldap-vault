Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"
  config.vm.provision "shell", path: "scripts/provision.sh"
  config.vm.provision "shell", path: "run.sh"
  config.vm.network "forwarded_port", guest: 8200, host: 8200
end
