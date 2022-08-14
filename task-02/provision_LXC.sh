#sudo apt-get update
#sudo apt-get install lxc lxc-templates systemd-services cgroup-bin \  bridge-utils debootstrap
#sudo -install
#apt install snapd -y
#snap refresh
#snap install core
#snap install lxd
#snap refresh
#sudo lxc-create -n test-container -t Centos
##############################
sudo apt-get update

sudo -i
apt remove gnupg -y
apt install --reinstall gnupg2 -y
apt install dirmngr

export DOWNLOAD_KEYSERVER="hkp://keyserver.ubuntu.com"
sudo apt-get install lxc lxc-templates
sudo systemctl start lxc.service
sudo systemctl enable lxc.service
sudo systemctl start lxc-net.service
sudo systemctl enable lxc-net.service

#sudo apt-get install lxc -y
sudo lxc-create -n test-container -t centos
lxc-create -n c1 -t download -- --dist centos --release 8-Stream --arch amd64 

sudo mkdir -p ~/.config/lxc/

sudo ln -s /etc/lxc/default.conf ~/.config/lxc/default.conf 
echo "
lxc.idmap = u 0 100000 65536
lxc.idmap = g 0 100000 65536" >> ~/.config/lxc/default.conf
sed -ie 's/lxc.apparmor.profile/unconfined/g' ~/.config/lxc/default.conf


echo "kernel.unprivileged_userns_clone=1" >> /etc/sysctl.conf 
