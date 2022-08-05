sudo dnf update
sudo dnf install dnf-utils
sudo yum -y install php
sudo yum install php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo
sudo dnf -y install mysql-server
sudo systemctl restart  httpd
sudo -i
sudo mkdir -p /var/www/php/html
sudo mkdir -p /var/www/php/log
sudo chown -R $USER:$USER /var/www/php/html
sudo chmod -R 755 /var/www
echo "<?php phpinfo(); ?>" > /var/www/php/html/info.php
#sudo vi /var/www/php/html/info.php
sudo mkdir /etc/httpd/sites-available /etc/httpd/sites-enabled
#sudo vi /etc/httpd/conf/httpd.conf
echo "
IncludeOptional conf.d/*.conf
IncludeOptional sites-enabled/*.conf
"  > /etc/httpd/conf/httpd.conf
#IncludeOptional conf.d/*.conf
#IncludeOptional sites-enabled/*.conf
#sudo vi /etc/httpd/sites-available/php.conf
echo "
<VirtualHost *:81>
ServerName www.php
ServerAlias php
DocumentRoot /var/www/php/html
ErrorLog /var/www/php/log/error.log
CustomLog /var/www/php/log/requests.log combined
</VirtualHost>
"  > /etc/httpd/sites-available/php.conf
sudo ln -s /etc/httpd/sites-available/php.conf /etc/httpd/sites-enabled/php.conf
sudo setsebool -P httpd_unified 1
sudo ls -dlZ /var/www/php/log/
sudo semanage fcontext -a -t httpd_log_t "/var/www/php/log(/.*)?"
sudo restorecon -R -v /var/www/php/log
sudo ls -dlZ /var/www/php/log/
sudo systemctl restart httpd
