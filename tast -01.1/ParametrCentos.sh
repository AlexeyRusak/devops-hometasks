sudo dnf update
sudo dnf install dnf-utils
sudo dnf install http://rpms.remirepo.net/enterprise/remi-release-8.rpm
sudo dnf module reset php
sudo dnf module install php:remi-8.0
sudo dnf -y install php
sudo dnf -y install mysql-server
sudo dnf install php-{common,mysql,xml,xmlrpc,curl,gd,imagick,cli,fpm,mbstring,opcache,zip}
sudo -i
echo "<?php phpinfo(); ?>" >> /var/www/html/info.php
firewall-cmd --zone=public --add-port=81/tcp
echo "
IncludeOptional conf.d/php.conf
Listen 81
"  >> /etc/httpd/conf/httpd.conf

sudo systemctl restart httpd