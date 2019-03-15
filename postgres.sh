#!/bin/bash

yum -y install python-pip python-devel gcc postgresql-server postgresql-devel postgresql-contrib
postgresql-setup initdb
systemctl start postgresql
vim /var/lib/pgsql/data/pg_hba.conf
sed -i 's,host    all             all             127.0.0.1/32            ident,host    all             all             127.0.0.1/32            md5,g' /var/lib/pgsql/data/pg_hba.conf
sed -i 's,host    all             all             ::1/128                 ident,host    all             all             ::1/128                 md5,g' /var/lib/pgsql/data/pg_hba.conf
systemctl restart postgresql
systemctl enable postgresql

echo "CREATE DATABASE myproject;
CREATE USER myprojectuser WITH PASSWORD 'password';
ALTER ROLE myprojectuser SET client_encoding TO 'utf8';
ALTER ROLE myprojectuser SET default_transaction_isolation TO 'read committed';
ALTER ROLE myprojectuser SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE myproject TO myprojectuser;" >> /tmp/tempfile

sudo -u postgres /bin/psql -f /tmp/phpmyadmin
yum install -y httpd

setsebool -P httpd_can_network_connect on
setsebool -P httpd_can_network_connect_db on

yum install php php-pgsql
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /var/lib/pgsql/data/postgresql.conf
sed -i 's/#port = 5432/port = 5432/'g /var/lib/pgsql/data/postgresql.conf

echo "CREATE USER pgdbuser CREATEDB CREATEUSER ENCRYPTED PASSWORD 'pgdbpass';
CREATE DATABASE mypgdb OWNER pgdbuser;
GRANT ALL PRIVILEGES ON DATABASE mypgdb TO pgdbuser;" > /tmp/phpmyadmin

sed -i 's/Require local/Require all granted/g' /etc/httpd/conf.d/phpPgAdmin.conf
sed -i 's/Denay from all/Allow all/g' /etc/httpd/conf.d/phpPgAdmin.conf

systemctl restart httpd
systemctl restart postgresql
sudo systemctl restart 

sed -i "s/$conf\['servers'\]\[0\]\['host'\] = '';/$conf['servers'][0]['host'] = 'localhost';/g" /etc/phpPgAdmin/config.inc.php
sed -i "s/$conf\['owned_only'\] = false;/$conf['owned_only'] = true;/g" /etc/phpPgAdmin/config.inc.php

systemctl reload httpd.service
systemctl restart postgresql

http://104.196.112.194/phpPgAdmin/