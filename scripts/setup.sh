#! /bin/bash
apt-get update -y
apt-get upgrade -y
apt-get install -y apache2 git
cd /var/www
git clone https://github.com/bellcom/display.git

sudo apt install ca-certificates apt-transport-https software-properties-common lsb-release -y
curl -sSL https://packages.sury.org/php/README.txt | sudo bash -x

apt-get update -y
apt-get upgrade -y

apt-get install -y apache2 pwgen mariadb-server libapache2-mod-php vim certbot python3-certbot-apache redis-server redis-tools composer libapache2-mod-php git php8.3 libapache2-mod-php8.3 php8.3-gd php8.3-xml zip unzip php8.3-curl php-xml php8.3-mysql

sudo a2enmod php8.3

sudo apt purge php8.2*
sudo a2enmod rewrite
systemctl restart apache2
chmod u+x /var/www/display/INSTALL.sh

