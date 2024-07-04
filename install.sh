#! /bin/bash
/usr/bin/php /var/www/display/create_site_with_db.php $1
rm -rf /etc/apache2/sites-enabled/000-default.conf
systemctl restart apache2
IFS='.' read -r -a array <<< $1
cd /var/www/$1
rm -rf ./public_html
git clone https://github.com/os2display/display-api-service.git public
apachectl graceful
cd /var/www/$1/public
read -p "Tryk pÃ¥enter for at fortsÃtte ..."
wget https://github.com/os2display/display-client/releases/download/2.0.3/display-client-2.0.3.tar.gz
tar -xvzf display-client-2.0.3.tar.gz
chown -R www-data: client/
cd /var/www/$1/public/client
cp example_config.json config.json
chown -R www-data: config.json
sed -i 's/os2display.example.org/'$1'/g' config.json
echo $1 ' er tilfÃ¸jet til config.json' 
read -p "Tryk pÃ¥enter for at fortsÃtte ..."
cd /var/www/$1/public
wget https://github.com/os2display/display-admin-client/releases/download/2.0.2/display-admin-client-2.0.2.tar.gz
tar -xvzf display-admin-client-2.0.2.tar.gz
chown -R www-data: admin/
cd /var/www/$1/public/admin
cp example_config.json config.json
cp example-access-config.json access-config.json 
chown -R www-data: config.json
chown -R www-data: access-config.json
cd /var/www/$1/public
cp .env .env.local
echo 'Aaben filen .env.local i ./public folderen og tilret redis og db connections' 
mapfile -t a < /var/www/$1/db.txt
declare "${a[@]}"
echo $DBNAME $DBUSERNAME $DBPASS 
sed -i 's/db:db/'$DBUSERNAME':db/g' .env.local
sed -i 's/:db@/:'$DBPASS'@/g' .env.local
sed -i 's/mariadb/localhost/g' .env.local
sed -i 's/db?/'$DBNAME'?/g' .env.local
read -p "Tryk pÃ¥enter for at fortsÃtte ..."
sed -i 's/redis:6379/localhost:6379/g' .env.local
sed -i 's/displayapiservice.local.itkdev.dk/'$1'/g' .env.local
sed -i 's/post_max_size = 8M/post_max_size = 200M/g' /etc/php/8.3/cli/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 200M/g' /etc/php/8.3/cli/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 200M/g' /etc/php/8.3/apache/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 200M/g' /etc/php/8.3/cli/php.ini
apachectl graceful
cp /var/www/display/patch/Media.php /var/www/$1/public/src/Entity/Tenant/Media.php 
composer require predis/predis
composer install --optimize-autoloader
composer install
/usr/bin/php -q /var/www/$1/public/bin/console doctrine:query:sql "show tables"
/usr/bin/php -q /var/www/$1/public/bin/console doctrine:schema:create
/usr/bin/php -q /var/www/$1/public/bin/console cache:clear
ls -la /var/www/$1/public/config/jwt/
/usr/bin/php -q /var/www/$1/public/bin/console app:tenant:add
read -p "Skriv vÃrdien fra det fÃrste felt du udfyldte i tenant oprettelsen og tryk enter " tenant
/usr/bin/php -q /var/www/$1/public/bin/console app:user:add admin@bellcom.dk d3m0d15pl4y Admin admin $tenant
chown -R www-data: /var/www/$1
