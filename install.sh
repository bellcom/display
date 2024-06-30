#!/bin/bash

cd /var/www
scp 78.47.233.32:/var/www/fix-www-permissions.sh ./
scp 78.47.233.32:/var/www/create_site_with_db.php ./
scp 78.47.233.32:/var/www/display.devel.dk/public_html/install_layouts.sh ./
scp 78.47.233.32:/var/www/display.devel.dk/public_html/install_templates.sh ./
chmod a+x create_site_with_db.php
chmod a+x fix-www-permissions.sh
chmod a+x install_layouts.sh
chmod a+x install_templates.sh

rm -rf /etc/apache2/sites-enabled/000-default.conf


