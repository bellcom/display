#! /bin/bash
systemctl restart apache2
cd /var/www/$1
rm -rf ./public_html
git clone https://github.com/os2display/display-api-service.git public
apachectl graceful
cd ./public_html
wget https://github.com/os2display/display-client/releases/download/2.0.3/display-client-2.0.3.tar.gz
tar -xvzf display-client-2.0.3.tar.gz
chown -R www-data: client/
cd client
cp example_config.json config.json
chown -R www-data: config.json
echo 'Aaben filen config.json i ./client folderen og tilret domanet' 
cd /var/www/$1
cd ./public_html
wget https://github.com/os2display/display-admin-client/releases/download/2.0.2/display-admin-client-2.0.2.tar.gz
tar -xvzf display-admin-client-2.0.2.tar.gz
chown -R www-data: admin/
cd admin
cp example_config.json config.json
cp example-access-config.json access-config.json 
chown -R www-data: config.json
chown -R www-data: access-config.json
echo 'Aaben filen config.json i ./admin folderen og tilret domanet' 
cd /var/www/$1/public_html
cp .env .env.local
echo 'Aaben filen .env.local i ./public_html folderen og tilret redis og db connections' 
apachectl graceful
composer require predis/predis
composer install --optimize-autoloader
composer install
php bin/console doctrine:query:sql "show tables"
php bin/console doctrine:schema:create
php bin/console cache:clear
ls -la config/jwt/
php bin/console app:tenant:add
php bin/console app:user:add admin@bellcom.dk d3m0d15pl4y Admin admin bellcom
cd ./public
ln -s ./../client/
ln -s ./../admin/

