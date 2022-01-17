#!/usr/bin/env bash

MYSQL_ROOT_PASSWORD='chocolate'
MYSQL_MLINVOICE_PASSWORD='strawberry'

echo "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD" | debconf-set-selections

echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
echo "postfix postfix/mailname string `hostname --domain`" | debconf-set-selections

apt-get -y update
apt-get -y upgrade

apt-get -y install apache2 php libapache2-mod-php php-xml php-curl php-mbstring mysql-server php-mysql php-zip unzip mailutils

# multipath spams journal. Since we don't need it, just remove it.
apt-get -y remove multipath-tools

a2enmod rewrite

echo "Configuring Apache"
cat << EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    DocumentRoot "/data/mlinvoice"

    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined

    <Directory "/data/mlinvoice">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

systemctl restart apache2
systemctl restart postfix

echo "Configuring MySQL"
systemctl stop mysql
sed -i -r "s/(#\s*)?datadir\s*=.*/datadir = \/data\/mysql\/db/" /etc/mysql/mysql.conf.d/mysqld.cnf
echo "[mysqld]" > /etc/mysql/mysql.conf.d/no-native-aio.cnf
echo "innodb_use_native_aio = 0" >> /etc/mysql/mysql.conf.d/no-native-aio.cnf
ln -s /etc/apparmor.d/usr.sbin.mysqld /etc/apparmor.d/disable/
apparmor_parser -R /etc/apparmor.d/usr.sbin.mysqld
NEWDB=0
if [ ! -e /data/mysql/db ]; then
  mkdir /data/mysql
  mysqld --initialize-insecure
  NEWDB=1
fi
systemctl reload apparmor
systemctl daemon-reload
systemctl start mysql

cd /tmp
echo "Checking MLInvoice version information"
ZIP=`curl -s 'https://www.labs.fi/mlinvoice_version.php?channel=production&filename=1'`
rm -rf *.zip
echo "Downloading $ZIP"
wget -q $ZIP
cd /data
unzip -o /tmp/*.zip
cd /data/mlinvoice
cp -n config.php.sample config.php
sed -i -r "s/define\('_DB_PASSWORD_', '.*?'\);/define('_DB_PASSWORD_', '$MYSQL_MLINVOICE_PASSWORD');/" config.php
KEY=`tr -dc A-Za-z0-9 </dev/urandom | head -c 32`
sed -i -r "s/define\('_ENCRYPTION_KEY_', '.*?'\);/define('_ENCRYPTION_KEY_', '$KEY');/" config.php

if [ $NEWDB -eq 1 ]; then
  mysqladmin -uroot --skip-password create mlinvoice
  cat << EOF | mysql -uroot --skip-password
use mlinvoice;
source /data/mlinvoice/create_database.sql;
create user 'mlinvoice'@'localhost' identified by '$MYSQL_MLINVOICE_PASSWORD';
grant all on mlinvoice.* to 'mlinvoice'@'localhost';
alter user 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD';
flush privileges;
EOF
else
  echo "Using existing MLInvoice database found in data/mysql"
fi
echo "Installation complete"

