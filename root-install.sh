#!/usr/bin/env bash

SITE='unittestingdemo'
DOMAIN='unittestingdemo.dev'

echo "---- update apt-get ----"
sudo apt-get update

echo "---- setup database ----"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

echo "---- install libraries for php5.5 ----"

sudo apt-get install -y vim curl python-software-properties

echo "---- add apt-repository for php5.5 ----"

sudo add-apt-repository -y ppa:ondrej/php5

echo "---- update apt-get (again, now that we have the new repository) ----"

sudo apt-get update

echo "---- install libraries ----"

sudo apt-get install -y subversion php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt mysql-server-5.5 php5-mysql git-core

echo "--- Installing and configuring Xdebug ---"
sudo apt-get install -y php5-xdebug


cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=0
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

echo "---- enable mod rewrite ----"

sudo a2enmod rewrite

echo "---- download composer ----"

curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

echo "---- setup root directory ----"

mkdir -p /vagrant/
sudo rm -rf /var/www/html
sudo ln -fs /vagrant/ /var/www/html

echo "---- turn on error reporting ----"

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

echo "---- set apache configurations ----"

sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

echo "---- restart apache ----"

sudo service apache2 restart

echo "---- create database ----"

mysqladmin -uroot -proot create $SITE
cd /vagrant


echo "---- install wp-cli ----"

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
chmod u+rwx /usr/local/bin/wp

echo "--- Done with root stuff ---"
