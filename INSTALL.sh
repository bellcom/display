#!/bin/bash


#---
# System changes before installation
#---

# Getting comand line argument no 1
IFS='.' read -r -a array <<< $1

if [ -z $1 ]; then 
	printf "
	No domain name given\n
	Usage: ./INSTALL.sh your.domanin.com\n
	For further help type ./INSTALL.sh help
	For system info and version type ./INSTALL.sh info
	For OS2display management type ./INSTALL.sh display\n\n"
	exit
fi
if [ "$1" = "help" ]; then 
	printf "
	Help section\n
	For further help type ./INSTALL.sh help
	For system info and version type ./INSTALL.sh info
	For OS2display management type ./INSTALL.sh display\n\n"
	exit
fi
if [ "$1" = "info" ]; then 
	printf "
	Info section\n
	For further help type ./INSTALL.sh help
	For system info and version type ./INSTALL.sh info
	For OS2display management type ./INSTALL.sh display\n\n"
	exit
fi
if [ "$1" = "display" ]; then 
	printf "
	Display management\n
	For further help type ./INSTALL.sh help
	For system info and version type ./INSTALL.sh info
	For OS2display management type ./INSTALL.sh display\n\n"
	exit
fi

if [ "$1" = "help" ]; then 
	printf "\n./INSTALL.sh help\n"
	exit
fi

# Setting permissions for the template and layout script
chmod a+x /var/www/display/scripts/install_templates.sh
chmod a+x /var/www/display/scripts/install_layouts.sh

# Dropping the database if it exists
mysql=$(mysql -u root -e 'show databases;')
check_db=${1//./_}
echo $check_db
echo $mysql;
if [[ $mysql == *"$check_db"* ]]; then
	read -p "Database exists - Do you want to drop user and database and continue (y/n) ?" -n 1 -r
	if [[ $REPLY =~ ^[Nn]$ ]]
	then
		exit
	else
		mysql_user_name_max=${check_db:0:15}
		mysql -u root -D mysql -e 'DELETE from user where User = "'$mysql_user_name_max'"';
		printf "\nUser dropped - continuing\n"
		mysql=$(mysql -u root -e 'DROP DATABASE '$check_db';')
		printf "\nDatabase dropped - continuing\n"
	fi	
fi

#check_db_length=${#check_db}
#mysql_user_name_max=$check_db
#if [ "$check_db_length" > "16" ]
#echo $mysql_user_name_max
#if [ "$mysql_user_name_max" > "16" ]
#then
#fi

#echo $mysql_user_name_max
# Creating DB, docroot and vhost for the site
/usr/bin/php /var/www/display/scripts/create_site_with_db.php $1

# Changing PHP defaults to the needed max MB
sed -i 's/post_max_size = 8M/post_max_size = 200M/g' /etc/php/8.3/cli/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 200M/g' /etc/php/8.3/cli/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 200M/g' /etc/php/8.3/apache2/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 200M/g' /etc/php/8.3/apache2/php.ini

# Implementing OS2display vhost templare from /var/www/display/templates
cp /var/www/display/templates/apache2.vhost.conf /etc/apache2/sites-available/$1.conf
sed -i 's/DOMAIN/'$1'/g' /etc/apache2/sites-available/$1.conf

# Restarting Apache webserver to load new configuration
systemctl restart apache2

# Cleaning up default files that are not needed
rm -rf /etc/apache2/sites-enabled/000-default.conf
rm -rf /var/www/$1/public_html


#---
# OS2display API
#---

# Cloning the OS2display API into ./public
cd /var/www/$1
git clone https://github.com/os2display/display-api-service.git public_html

# Setup of the API setup
cd /var/www/$1/public_html
mapfile -t a < /var/www/$1/db.txt
declare "${a[@]}"
cp .env .env.local

# Writing the DB info and domain changes to the .env.local file.
sed -i 's/db:db/'$DBUSERNAME':db/g' .env.local
sed -i 's/:db@/:'$DBPASS'@/g' .env.local
sed -i 's/mariadb/localhost/g' .env.local
sed -i 's/db?/'$DBNAME'?/g' .env.local
sed -i 's/redis:6379/localhost:6379/g' .env.local
sed -i 's/displayapiservice.local.itkdev.dk/'$1'/g' .env.local

# Moving install scripts
cp /var/www/display/scripts/install_templates.sh /var/www/$1/public_html/
cp /var/www/display/scripts/install_layouts.sh /var/www/$1/public_html/


#---
# OS2display client
#---

# Cloning the OS2display client into ./public_html/client 
cd /var/www/$1/public_html
wget https://github.com/os2display/display-client/releases/download/2.0.3/display-client-2.0.3.tar.gz
tar -xvzf display-client-2.0.3.tar.gz
chown -R www-data: client/

# Setup of the client configuration
cd /var/www/$1/public_html/client
cp example_config.json config.json
chown -R www-data: config.json
sed -i 's/os2display.example.org/'$1'/g' config.json
echo $1 ' Has been added to config.json' 


#---
# OS2display sdmin client
#---

# Cloning the OS2display admin client into ./public_html/admin
cd /var/www/$1/public_html
wget https://github.com/os2display/display-admin-client/releases/download/2.0.2/display-admin-client-2.0.2.tar.gz
tar -xvzf display-admin-client-2.0.2.tar.gz
chown -R www-data: admin/

# Setup of the admin client configuration
cd /var/www/$1/public_html/admin
cp example_config.json config.json
cp example-access-config.json access-config.json 
chown -R www-data: config.json
chown -R www-data: access-config.json

# File that has been changed and needs a patch - planned
cp /var/www/display/patch/Media.php /var/www/$1/public_html/src/Entity/Tenant/Media.php 

# Composer install
composer require predis/predis
composer install --optimize-autoloader
composer install

# To be removed
#/usr/bin/php -q /var/www/$1/public/bin/console doctrine:query:sql "show tables"

# Creating Symfony DB schema via Doctrine / the console
/usr/bin/php -q /var/www/$1/public_html/bin/console doctrine:schema:create
/usr/bin/php -q /var/www/$1/public_html/bin/console cache:clear

# Generating needed JWT keypair
/usr/bin/php -q /var/www/$1/public_html/bin/console lexik:jwt:generate-keypair
ls -la /var/www/$1/public_html/config/jwt/


# Adding Tennant before creating the admin user 
/usr/bin/php -q /var/www/$1/public_html/bin/console app:tenant:add
echo "As the last field in the user creation. Ad the tenant. The value from the first field in the tennant creation "
/usr/bin/php -q /var/www/$1/public_html/bin/console app:user:add 

# Linking the admin and client folders into the document root. 
ln -s /var/www/$1/public_html/admin /var/www/$1/public_html/public/admin
ln -s /var/www/$1/public_html/client /var/www/$1/public_html/public/client

# Running Symfony install commands for templates and layouts.
chown -R www-data: /var/www/$1
cd /var/www/$1/public_html
./install_templates.sh
./install_layouts.sh

