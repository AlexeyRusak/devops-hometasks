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

sudo apt-get install lxc -y
sudo lxc-create -n test-container -t centos
lxc-create -n c1 -t download -- --dist centos --release 8-Stream --arch amd64 