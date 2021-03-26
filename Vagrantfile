Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"
  config.vm.provision "shell", path: "scripts/provision.sh"
  config.vm.provision "shell", path: "run.sh"
end
