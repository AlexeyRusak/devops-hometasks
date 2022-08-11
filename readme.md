# Vagrant Cloud 

- Ссылка https://app.vagrantup.com/alexey_rusak/boxes/centos8

# Vagrantfile

  Необходимо поместить в Vagrantfile:
  
    Vagrant.configure("2") do |config|
      config.vm.box = "alexey_rusak/centos8"
      config.vm.box_version = "1"
      config.vm.network "forwarded_port", guest: 80, host: 8080
      config.vm.network "forwarded_port", guest: 81, host: 8081
    end
    
  
  
