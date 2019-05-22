#!/usr/bin/env bash

DB_ROOT_PASS="mariadb_root_password"
DB_USER="mariadb_user"
DB_PASS="mariadb_user_password"

# install mariadb
#mysql_install_db --user=mysql --datadir="/var/lib/mysql"

#start mariadb 
#defualt is already running in my setting
#sudo rc-service mariadb start

# set root passwort
sudo /usr/bin/mysqladmin -u root password "${DB_ROOT_PASS}"

#create a user and give previliges
echo "GRANT ALL ON *.* TO ${DB_USER}@'127.0.0.1' IDENTIFIED BY '${DB_PASS}' WITH GRANT OPTION;" > /tmp/sql
echo "GRANT ALL ON *.* TO ${DB_USER}@'localhost' IDENTIFIED BY '${DB_PASS}' WITH GRANT OPTION;" >> /tmp/sql
echo "GRANT ALL ON *.* TO ${DB_USER}@'::1' IDENTIFIED BY '${DB_PASS}' WITH GRANT OPTION;" >> /tmp/sql
echo "DELETE FROM mysql.user WHERE User='';" >> /tmp/sql
echo "DROP DATABASE test;" >> /tmp/sql
echo "FLUSH PRIVILEGES;" >> /tmp/sql
cat /tmp/sql | mysql -u root --password="${DB_ROOT_PASS}"

# modify the settings for size
sudo sed -i "s|max_allowed_packet\s*=\s*1M|max_allowed_packet = ${MAX_ALLOWED_PACKET}|g" /etc/mysql/my.cnf
sudo sed -i "s|max_allowed_packet\s*=\s*16M|max_allowed_packet = ${MAX_ALLOWED_PACKET}|g" /etc/mysql/my.cnf

# restart
sudo rc-service mysqld restart
