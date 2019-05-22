#!/usr/bin/env bash

# set root passwort
sudo /usr/bin/mysqladmin -u root password 'password' 

# allow remote access
mysql -u root -ppassword -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;"

# drop the anonymous users
mysql -u root -ppassword -e "DROP USER ''@'localhost';"
mysql -u root -ppassword -e "DROP USER ''@'$(hostname)';"

# drop the demo database
mysql -u root -ppassword -e "DROP DATABASE test;"

# flush
mysql -u root -ppassword -e "FLUSH PRIVILEGES;"

# restart
sudo rc-service mysqld restart