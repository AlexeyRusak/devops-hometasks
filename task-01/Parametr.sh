sudo apt update
sudo apt -y install php
sudo apt -y install libapache2-mod-php
sudo systemctl restart apache2
echo "<?php phpinfo(); ?>" > /var/www/html/info.php
sudo systemctl restart apache2




