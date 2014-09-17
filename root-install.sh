#!/usr/bin/env bash

SITE='unittestingdemo'
DOMAIN='unittestingdemo.dev'
USER='user'
PASSWORD='password'
ADMIN_EMAIL='test@test.com'

sudo apt-get update

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

sudo apt-get install -y vim curl python-software-properties

sudo add-apt-repository -y ppa:ondrej/php5

sudo apt-get update

sudo apt-get install -y php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt mysql-server-5.5 php5-mysql git-core

sudo a2enmod rewrite

echo "--- Setting document root ---"
mkdir -p /vagrant/
sudo rm -rf /var/www/html
sudo ln -fs /vagrant/ /var/www/html


sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

echo "--- Restarting Apache ---"
sudo service apache2 restart


mysqladmin -uroot -proot create $SITE
cd /vagrant


# let's install wp-cli

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
chmod u+rwx /usr/local/bin/wp

echo "--- Done with root stuff ---"
