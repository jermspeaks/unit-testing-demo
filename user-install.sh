SITE='unittestingdemo'
USER='user'
PASSWORD='password'
ADMIN_EMAIL='test@test.com'
DOMAIN='unittestingdemo.dev'


cd /var/www/html
wp core download  --path="/var/www/html"
wp core config --dbname=unittestingdemo --dbuser=root --dbpass=root
wp core install --title="Your Blog Title" --admin_user="$USER" --admin_password="$PASSWORD" --admin_email="$ADMIN_EMAIL"  --path="/var/www/html" --url="$DOMAIN"  
echo "--- Done with vagrant user stuff ---"