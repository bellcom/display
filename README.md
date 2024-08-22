# OSdisplay
Os2display install profile without docker

Se usefull links at the buttom of the readme file. 

## How to install OS2display
This installation has been tested for Debian 12 server version and Ubuntu 24.04 server version. 
Both should work on the Desktop versiona as well. 

### Installation needs
- Server: Debain 12 or Ubuntu 24.04
- Root or sudo access
- A valid dns name that points to the ip address of your server

### Installation - step 1 - Server components
Issue the commands below and the needed server components will be installed  
(You can copy and paste all commands - except sudo - in one copy past to a terminal - they will execute after each other)

```bash
sudo -s
wget -P /var/ https://raw.githubusercontent.com/bellcom/display/main/scripts/setup.sh 
chmod a+x /var/setup.sh
cd /var
./setup.sh
```

### Installation - step 2 - OS2display
Issue the commands below to install OS2display and follow the instructions
DB credentials are saved in /var/www/[your_domain]
```bash
cd /var/www/display
/var/www/display/INSTALL.sh your-domain
```


## LINKS
Symfony for Apache configuration: https://symfony.com/doc/current/setup/web_server_configuration.html
 
