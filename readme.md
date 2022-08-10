# Vagrant Cloud 

- Ссылка https://app.vagrantup.com/alexey_rusak/boxes/centos8

# Vagrantfile
  Vagrant.configure("2") do |config|
    config.vm.box = "alexey_rusak/centos8"
    config.vm.box_version = "1"
  end
