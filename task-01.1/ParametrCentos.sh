sudo dnf update
sudo dnf install dnf-utils
sudo dnf install http://rpms.remirepo.net/enterprise/remi-release-8.rpm
sudo dnf module reset php
sudo dnf module install php:remi-8.0
sudo dnf -y install php
sudo dnf -y install mysql-server
sudo -i
sudo mkdir -p /var/www/php
echo "<?php phpinfo(); ?>" >> /var/www/php/index.php
firewall-cmd --zone=public --add-port=81/tcp
echo "
IncludeOptional conf.d/*.conf
IncludeOptional sites-enabled/*.conf
Listen 81
"  >> /etc/httpd/conf/httpd.conf

sudo systemctl restart httpd
sudo -i
sudo firewall-cmd --permanent --add-service=http
sudo mkdir /etc/httpd/sites-available /etc/httpd/sites-enabled
echo "
<VirtualHost *:80>
  DocumentRoot "/var/www/html"
</VirtualHost>
<VirtualHost *:81>
  DocumentRoot "/var/www/php/index.php"
</VirtualHost>
"  >> /etc/httpd/sites-available/php.conf
sudo ln -s /etc/httpd/sites-available/php.conf /etc/httpd/sites-enabled/php.conf
sudo setsebool -P httpd_unified 1
sudo systemctl restart httpd

