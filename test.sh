#! /bin/bash
cd /var/www/$1/client
sed -i 's/os2display.example.org/'.$1.'/g' config.json
