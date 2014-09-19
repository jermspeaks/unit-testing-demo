SITE='unittestingdemo'
USER='user'
PASSWORD='password'
ADMIN_EMAIL='test@test.com'
DOMAIN='unittestingdemo.dev'


echo "--- Set up WordPress and add/setup our demo plugin ---"

cd /vagrant

if [ ! -f /vagrant/wp-config.php ]; then
	wp core download  --path="/vagrant"
	wp core config --dbname=unittestingdemo --dbuser=root --dbpass=root
	wp core install --title="Your Blog Title" --admin_user="$USER" --admin_password="$PASSWORD" --admin_email="$ADMIN_EMAIL"  --path="/vagrant" --url="$DOMAIN"  
	cp -r /vagrant/demo-plugin/ /vagrant/wp-content/plugins/
	wp plugin activate demo-plugin --path="/vagrant"

	echo "--- Add composer to path variable and source ~/.bash_profile ---"

	echo 'export PATH=~/.composer/vendor/bin/:$PATH' >>~/.bash_profile
	source ~/.bash_profile

	echo "--- Globally install phpunit ---"

	composer global require "phpunit/phpunit=4.2.*"


	echo "--- Done with vagrant user stuff ---"
fi