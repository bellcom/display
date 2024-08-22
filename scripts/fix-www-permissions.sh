#!/bin/bash
#
# FROM PUPPET. DONT EDIT
#
# Try to set correct permissions for files under /var/www/
#

if [ $UID -ne 0 ] ; then
  echo "Please run as root or with sudo (sudo $0)"
  exit 1
fi

PWD=`pwd`
PATHARRAY=( `echo ${PWD} | tr '/' ' '`)

if [[ ${PATHARRAY[1]} != 'www'  ]]; then
  echo "not in a www dir"
  exit 1
fi

echo "Going to recursively change group and permissionson on $PWD"
read -p "Press [Enter] to start or ctrl-c to cancel"
chgrp --preserve-root -R www-data "$PWD"
#chmod --preserve-root -R ug+rwX "$PWD"
#chmod --preserve-root -R o-w "$PWD"
find "$PWD" -type d -exec chmod g+s '{}' \;

find "$PWD" -type d -exec chmod 775 '{}' \;
find "$PWD" -type f -exec chmod 664 '{}' \;

# Allow execute for .sh files
if [ -d $PWD"/public_html/scripts" ]; then
  chmod --preserve-root -R ug+x $PWD"/public_html/scripts"
fi

# Allow execute for .sh files in subsites
if [ -d $PWD"/scripts" ]; then
  chmod --preserve-root -R ug+x $PWD"/scripts"
fi

# For WordPress
find "$PWD" -name wp-config.php -exec chmod 444 '{}' \;

# Set correct permissions for Drupal
if [ -d $PWD"/public_html/sites/default" ]; then
  chmod --preserve-root a-w $PWD"/public_html/sites/default"
fi
if [ -d $PWD"/sites/default" ]; then
  chmod --preserve-root a-w $PWD"/sites/default"
fi
if [ -f $PWD"/public_html/sites/default/settings.php" ]; then
  chmod --preserve-root a-w $PWD"/public_html/sites/default/settings.php"
fi
if [ -f $PWD"/sites/default/settings.php" ]; then
  chmod --preserve-root a-w $PWD"/sites/default/settings.php"
fi
if [ -f $PWD"/vendor/drush/drush/drush" ]; then
  chmod --preserve-root ug+x $PWD"/vendor/drush/drush/drush"
fi

echo "Done"
