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
iptables -t nat -A PREROUTING -p tcp -i eth0 --dport 81 -j DNAT --to-destination 10.0.3.81

echo "kernel.unprivileged_userns_clone=1" >> /etc/sysctl.conf 

sed -ie 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0 systemd.legacy_systemd_cgroup_controller=yes"/g' /etc/default/grub
sudo update-grub

sudo mkdir -p ~/.config/lxc/
sudo touch ~/.config/lxc/default.conf 
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
echo "
dhcp-host=c1,10.0.3.80
dhcp-host=c2,10.0.3.81
" >> /etc/default/lxc-dhcp.conf
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
###########################################    LXC     ####################################################################################
lxc-create -n c1 -f /root/.config/lxc/default.conf -t download -- --dist centos --release 8-Stream --arch amd64 --keyserver hkp://keyserver.ubuntu.com 
lxc-create -n c2 -f /root/.config/lxc/default.conf -t download -- --dist centos --release 8-Stream --arch amd64 --keyserver hkp://keyserver.ubuntu.com 
lxc-start c1
lxc-start c2
sleep 10

###########################################    HTTP     ####################################################################################
sudo -i
lxc-attach c1 -- yum install -y -q httpd httpd-devel httpd-tools
lxc-attach c1 -- mkdir -p /var/www/html
cp /home/index.html /var/lib/lxc/c1/rootfs/var/www/html
lxc-attach c1 -- touch /etc/httpd/conf.d/http.conf 

echo "
<VirtualHost *:80>
  DocumentRoot "/var/www/html"
</VirtualHost>" >> /var/lib/lxc/c1/rootfs/etc/httpd/conf.d/http.conf

lxc-attach c1 -- systemctl restart httpd
############################################## PHP #################################################################################
sudo -i
lxc-attach c2 -- yum install -y -q httpd httpd-devel httpd-tools php
lxc-attach c2 -- sudo mkdir -p /var/www/php
cp /home/index.php /var/lib/lxc/c2/rootfs/var/www/php/index.php

lxc-attach c2 -- systemctl restart httpd

echo "
IncludeOptional sites-enabled/*.conf
Listen 81
"  >> /var/lib/lxc/c2/rootfs/etc/httpd/conf/httpd.conf

lxc-attach c2 -- sudo systemctl restart httpd
lxc-attach c2 -- sudo systemctl enable httpd
lxc-attach c2 -- sudo mkdir /etc/httpd/sites-available /etc/httpd/sites-enabled
echo "
<VirtualHost *:81>
  DocumentRoot "/var/www/php/index.php"
</VirtualHost>
"  >> /var/lib/lxc/c2/rootfs/etc/httpd/sites-available/php.conf
lxc-attach c2 -- sudo ln -s /etc/httpd/sites-available/php.conf /etc/httpd/sites-enabled/php.conf
lxc-attach c2 -- sudo systemctl restart httpd
###############################################################################################################################