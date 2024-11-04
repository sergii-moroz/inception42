#/bin/ash

if [ ! -f "/var/www/html/wp-config.php" ]; then
	cd /var/www/html
	wp core download

	read -r WP_ADMIN_USER		< $WP_ADMIN_USER_FILE
	read -r WP_ADMIN_PASSWORD	< $WP_ADMIN_PASSWORD_FILE
	read -r WP_ADMIN_EMAIL		< $WP_ADMIN_EMAIL_FILE

	read -r WP_USER				< $WP_USER_FILE
	read -r WP_USER_PASSWORD	< $WP_USER_PASSWORD_FILE
	read -r WP_USER_EMAIL		< $WP_USER_EMAIL_FILE

	until mariadb -h"mariadb" -u$WP_ADMIN_USER -p$WP_ADMIN_PASSWORD -e "show databases;" > /dev/null 2>&1;do
		sleep 5
		echo "connecting ..."
	done

	wp config create \
		--allow-root \
		--dbhost=$WP_DB_HOST \
		--dbname=$WP_DB_NAME \
		--dbuser=$WP_ADMIN_USER \
		--dbpass=$WP_ADMIN_PASSWORD \
		--path="/var/www/html" \
		--dbprefix="wp_" \
		--dbcharset="utf8mb4"

	# ./wp-cli.phar db create

	wp core install \
		--url=$WP_URL \
		--title="Inception42-smoroz" \
		--admin_user=$WP_ADMIN_USER \
		--admin_password=$WP_ADMIN_PASSWORD \
		--admin_email=$WP_ADMIN_EMAIL \
		--allow-root

	wp user create $WP_USER $WP_USER_EMAIL \
		--user_pass=$WP_USER_PASSWORD \
		--role=author \
		--allow-root
fi

php-fpm82 -F
