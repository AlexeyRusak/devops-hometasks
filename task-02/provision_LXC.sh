sudo apt-get update

sudo -i
apt remove gnupg -y
apt install --reinstall gnupg2 -y
apt install dirmngr

sudo apt-get install lxc lxc-templates -y
sudo systemctl start lxc.service
sudo systemctl enable lxc.service
sudo systemctl start lxc-net.service
sudo systemctl enable lxc-net.service
systemctl restart lxc-net

iptables -t nat -A PREROUTING -p tcp -i eth0 --dport 80 -j DNAT --to-destination 10.0.3.80

echo "kernel.unprivileged_userns_clone=1" >> /etc/sysctl.conf 

sed -ie 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0 systemd.legacy_systemd_cgroup_controller=yes"/g' /etc/default/grub
sudo update-grub

sudo mkdir -p ~/.config/lxc/
sudo ln -s /etc/lxc/default.conf ~/.config/lxc/default.conf 
echo "
lxc.net.0.type = veth
lxc.net.0.flags = up
lxc.net.0.link = lxcbr0

lxc.apparmor.profile = unconfined
lxc.apparmor.allow_nesting = 1
" > ~/.config/lxc/default.conf

echo 'export DOWNLOAD_KEYSERVER="hkp://keyserver.ubuntu.com"' >> ~/.bashrc

echo "vagrant veth lxcbr0 10" >> /etc/lxc/lxc-usernet

touch /etc/default/lxc-dhcp.conf
echo "dhcp-host=c1,10.0.3.80" >> /etc/default/lxc-dhcp.conf
systemctl restart lxc-net

echo '
USE_LXC_BRIDGE="true"
LXC_BRIDGE="lxcbr0"
LXC_ADDR="10.0.3.1"
LXC_NETMASK="255.255.255.0"
LXC_NETWORK="10.0.3.0/24"
LXC_DHCP_RANGE="10.0.3.2,10.0.3.254"
LXC_DHCP_MAX="253"
LXC_DHCP_CONFILE="/etc/default/lxc-dhcp.conf"
LXC_DOMAIN=""
' >>/etc/default/lxc-net
systemctl restart lxc-net

lxc-create -n c1 -f /root/.config/lxc/default.conf -t download -- --dist centos --release 8-Stream --arch amd64 --keyserver hkp://keyserver.ubuntu.com 
lxc-start c1
sleep 10
lxc-attach c1 -- yum install -y -q httpd httpd-devel httpd-tools
lxc-attach c1 -- mkdir -p /var/www/html
lxc-attach c1 -- cp /home/index.html /var/www/html
lxc-attach c1 -- touch /etc/httpd/conf.d/http.conf 

echo "
<VirtualHost *:80>
  DocumentRoot "/var/www/html"
</VirtualHost>" >> /var/lib/lxc/c1/rootfs/etc/httpd/conf.d/http.conf

lxc-attach c1 -- systemctl restart httpd
###############################################################################################################################
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
# sudo apt-get update

# sudo -i
# apt remove gnupg -y
# apt install --reinstall gnupg2 -y
# apt install dirmngr


# echo "export DOWNLOAD_KEYSERVER="hkp://keyserver.ubuntu.com"" >> ~/.bashrc
# sudo mkdir -p ~/.config/lxc/



# sudo -i
# sudo apt-get install lxc lxc-templates -y
# sudo systemctl start lxc.service
# sudo systemctl enable lxc.service
# sudo systemctl start lxc-net.service
# sudo systemctl enable lxc-net.service
# systemctl restart lxc-net

# sudo cp /etc/lxc/default.conf ~/.config/lxc/default.conf  
# echo "
# lxc.idmap = u 0 100000 65536
# lxc.idmap = g 0 100000 65536" >> ~/.config/lxc/default.conf
# sed -ie 's/lxc.apparmor.profile/unconfined/g' ~/.config/lxc/default.conf


# echo "kernel.unprivileged_userns_clone=1" >> /etc/sysctl.conf 

# sed -ie 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0 systemd.legacy_systemd_cgroup_controller=yes"/g' /etc/default/grub
# sudo update-grub


# touch /etc/default/lxc-dhcp.conf
# echo "dhcp-host=c1,10.0.3.80" >> /etc/default/lxc-dhcp.conf

# systemctl reboot



# sudo -i
# echo "root veth lxcbr0 10" >> /etc/lxc/lxc-usernet
# echo '
# USE_LXC_BRIDGE="true"
# LXC_BRIDGE="lxcbr0"
# LXC_ADDR="10.0.3.1"
# LXC_NETMASK="255.255.255.0"
# LXC_NETWORK="10.0.3.0/24"
# LXC_DHCP_RANGE="10.0.3.2,10.0.3.254"
# LXC_DHCP_MAX="253"
# LXC_DHCP_CONFILE="/etc/default/lxc-dhcp.conf"
# LXC_DOMAIN=""
# ' >>/etc/default/lxc-net

# systemctl enable lxc-net
# systemctl start lxc-net

# echo "
# lxc.net.0.type  = veth
# lxc.net.0.flags = up
# lxc.net.0.link  = lxcbr0
# " >> ~/.config/lxc/default.conf

# iptables -t nat -A PREROUTING -p tcp -i eth0 --dport 80 -j DNAT --to-destination 10.0.3.80
# iptables -t nat -A PREROUTING -p tcp -i eth0 --dport 81 -j DNAT --to-destination 10.0.3.81

# #systemctl reboot
# #sudo apt-get install lxc -y
# #export DOWNLOAD_KEYSERVER="hkp://keyserver.ubuntu.com"
# #sudo lxc-create -n test-container -t centos

# systemctl reboot

# lxc-create -n c1 -t download -- --dist centos --release 8-Stream --arch amd64 --keyserver hkp://keyserver.ubuntu.com 
# lxc-start c1
# lxc-autostart c1 -a
# lxc-attach c1

# lxc-attach c1 -- yum install -y -q httpd httpd-devel httpd-tools
#  yum update -y
 
#    sudo yum -y install httpd
#    sudo systemctl start  httpd
#    sudo firewall-cmd --permanent --add-service=http
#    sudo firewall-cmd --reload
#    sudo dnf update
#  sudo dnf install dnf-utils
#  sudo dnf install http://rpms.remirepo.net/enterprise/remi-release-8.rpm
#  sudo dnf module reset php
# sudo dnf module install php:remi-8.0
#  sudo dnf -y install php
#  sudo dnf -y install mysql-server
#  sudo -i
# sudo mkdir -p /var/www/php
# echo "<?php phpinfo(); ?>" >> /var/www/php/index.php
# sudo firewall-cmd --zone=public --add-port=81/tcp --permanent
#  echo "
#  IncludeOptional conf.d/*.conf
# IncludeOptional sites-enabled/*.conf
#  Listen 81 
# "  >> /etc/httpd/conf/httpd.conf

#  sudo systemctl restart httpd
#  sudo -i
#  sudo firewall-cmd --runtime-to-permanent
#  sudo firewall-cmd --zone=public --add-service=https --permanent
#  sudo systemctl enable firewalld
#  sudo systemctl enable httpd
#  sudo mkdir /etc/httpd/sites-available /etc/httpd/sites-enabled
#  echo "
#  <VirtualHost *:80>
#    DocumentRoot "/var/www/html"
#  </VirtualHost>
#  <VirtualHost *:81>
#    DocumentRoot "/var/www/php/index.php"
#  </VirtualHost>
#  "  >> /etc/httpd/sites-available/php.conf
#  sudo ln -s /etc/httpd/sites-available/php.conf /etc/httpd/sites-enabled/php.conf
#  sudo setsebool -P httpd_unified 1
#  sudo systemctl restart httpd

# # # # new centos8
# # # #/var/lib/lxc/c1/rootfs
# # # #for centos
# # # #cp /home/vagrant/index.html /var/www/html
# # # #cp /home/vagrant/index.php /var/www/php