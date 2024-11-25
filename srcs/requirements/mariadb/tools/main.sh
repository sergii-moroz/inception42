#!/bin/ash

signal_terminate_trap() {
	mariadb-admin shutdown
	wait $!
	echo "MariaDB shut down successfully"
}

trap "signal_terminate_trap" SIGTERM

if [ ! -d "/run/maria" ]; then
	mkdir -p /run/maria
	chown -R mysql:mysql /run/maria
	chmod -R 775 /run/maria
fi

if [ ! -f "/var/lib/mysql/ibdata1" ]; then
	chown -R mysql:mysql /var/lib/mysql

	mariadb-install-db --user=mysql --datadir=/var/lib/mysql
	wait $!

	mariadbd &
	until mariadb -e "show databases;" > /dev/null 2>&1;do
		sleep 5
		echo "waiting connection to the DB ..."
	done

	read -r MYSQL_ROOT_USER		< $MYSQL_ROOT_USER_FILE
	read -r MYSQL_ROOT_PASSWORD	< $MYSQL_ROOT_PASSWORD_FILE
	read -r WP_ADMIN_USER		< $WP_ADMIN_USER_FILE
	read -r WP_ADMIN_PASSWORD	< $WP_ADMIN_PASSWORD_FILE

	mariadb -e "GRANT ALL ON *.* TO '$MYSQL_ROOT_USER'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;"
	mariadb -e "GRANT ALL ON *.* TO '$MYSQL_ROOT_USER'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;"

	mariadb -e "DELETE FROM mysql.user WHERE User = '';"
	mariadb -e "DROP USER IF EXISTS ''@'localhost';"
	mariadb -e "DROP DATABASE IF EXISTS test;"

	# Create database for the service "wordpress"
	mariadb -e "create database $WP_DB_NAME;"
	mariadb -e "grant all on $WP_DB_NAME.* to '$WP_ADMIN_USER'@'localhost' identified by '$WP_ADMIN_PASSWORD';"
	mariadb -e "grant all on $WP_DB_NAME.* to '$WP_ADMIN_USER'@'%' identified by '$WP_ADMIN_PASSWORD';"
	mariadb -e "FLUSH PRIVILEGES;"

	mariadb-admin shutdown
	wait $!
fi

exec mariadbd --user=mysql --datadir=/var/lib/mysql

wait $!
exit 0
