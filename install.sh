#! /bin/bash
#/usr/bin/php /var/www/display/create_site_with_db.php
rm -rf /etc/apache2/sites-enabled/000-default.conf
systemctl restart apache2
cd /var/www/$1
rm -rf ./public_html
git clone https://github.com/os2display/display-api-service.git public
apachectl graceful
cd /var/www/$1/public
wget https://github.com/os2display/display-client/releases/download/2.0.3/display-client-2.0.3.tar.gz
tar -xvzf display-client-2.0.3.tar.gz
chown -R www-data: client/
cd /var/www/$1/public/client
cp example_config.json config.json
chown -R www-data: config.json
sed -i 's/os2display.example.org/'.$1.'/g' config.json
echo $1 ' er tilføjet til config.json' 
cd /var/www/$1
wget https://github.com/os2display/display-admin-client/releases/download/2.0.2/display-admin-client-2.0.2.tar.gz
tar -xvzf display-admin-client-2.0.2.tar.gz
chown -R www-data: admin/
cd /var/www/$1/public/admin
cp example_config.json config.json
cp example-access-config.json access-config.json 
chown -R www-data: config.json
chown -R www-data: access-config.json
echo 'Aaben filen config.json i ./admin folderen og tilret domanet' 
cd /var/www/$1/public
cp .env .env.local
echo 'Aaben filen .env.local i ./public folderen og tilret redis og db connections' 
apachectl graceful
composer require predis/predis
composer install --optimize-autoloader
composer install
/usr/bin/php -q /var/www/$1/public/bin/console doctrine:query:sql "show tables"
/usr/bin/php -q /var/www/$1/public/bin/console doctrine:schema:create
/usr/bin/php -q /var/www/$1/public/bin/console cache:clear
ls -la /var/www/$1/public/config/jwt/
/usr/bin/php -q /var/www/$1/public/bin/console app:tenant:add
/usr/bin/php -q /var/www/$1/public/bin/console app:user:add admin@bellcom.dk d3m0d15pl4y Admin admin bellcom
cd /var/www/$1/public
ln -s ./../client/
ln -s ./../admin/

