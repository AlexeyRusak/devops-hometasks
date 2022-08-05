sudo apt update
sudo apt -y install php
sudo apt -y install libapache2-mod-php
sudo systemctl restart apache2
echo 'Listen 81' >> /etc/apache2/ports.conf
sudo mkdir -p /var/www/php
echo "<?php phpinfo(); ?>" > /var/www/php/info.php
echo "<VirtualHost *:81>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/php/info.php
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" > /etc/apache2/sites-available/000-default.conf

sudo systemctl restart apache2