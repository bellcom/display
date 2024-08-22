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

### Installation - step 1
```bash
sudo -s
wget https://raw.githubusercontent.com/bellcom/display/main/setup.sh /var/
chmod a+x /var/setup.sh
cd /var
/setup.sh
```


## LINKS
Symfony for Apache configuration: https://symfony.com/doc/current/setup/web_server_configuration.html
 
