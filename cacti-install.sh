#!/bin/bash

#install cacti and mariadb-server.
yum -y install cacti               # Installes a number of packages, including mariadb, httpd, php and so on
yum -y install mariadb-server         # The mysql/mariadb client installs with the cacti stack but not the server
                                   # If you want to have multiple cacti nodes, considder using the client and connecting
                                   # to another server
                 
#instal the php-process & php-gh 
#There is an additional code for the php in the web-a-continues
yum -y install php-process php-gd php mod_php
yum -y install net-snmp net-snmp-utils                                   

#Enable mariadb, httpd and snmpd
systemctl enable mariadb           
systemctl enable httpd
systemctl enable snmpd

#ssytem start for db, httpd and snmpd.
systemctl start mariadb         
systemctl start httpd
systemctl start snmpd

#Setting the password for the mysqladmin. (P@ssw0rd1)
mysqladmin -u root password P@ssw0rd1                               # Set your mysql/mariadb pasword.  here P@ssw0rd1 is your password
                                                                    # Make a sql script to create a cacti db and grant the cacti user access to it

#change the local timezone to the sql timezone.
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -p P@ssw0rd1 mysql

# Set this to somthing better than 'cactipass'
# Added to fix a timezone issue
#line 37 set the timezone to base on the mysql.timeszone
echo "create database cacti;
GRANT ALL ON cacti.* TO cacti@localhost IDENTIFIED BY 'P@ssw0rd1';  
FLUSH privileges;
GRANT SELECT ON mysql.time_zone_name TO cacti@localhost;           
flush privileges;" > stuff.sql


mysql -u root  -pP@ssw0rd1 < stuff.sql    # Run your sql script
rpm -ql cacti|grep cacti.sql     # Will list the location of the package cacti sql script
                                 # In this case, the output is /usr/share/doc/cacti-1.0.4/cacti.sql, run that to populate your db

mypath=$(rpm -ql cacti|grep cacti.sql)
mysql cacti < $mypath -u cacti -pP@ssw0rd1
  
#mysql -u cacti -p cacti < /usr/share/doc/cacti-1.0.4/cacti.sql

# Open up apache
sed -i 's/Require host localhost/Require all granted/' /etc/httpd/conf.d/cacti.conf
sed -i 's/Allow from localhost/Allow from all all/' /etc/httpd/conf.d/cacti.conf

# Modify cacti credencials to use user cacti P@ssw0rd1
#make sure 
sed -i "s/\$database_username = 'cactiuser';/\$database_username = 'cacti';/" /etc/cacti/db.php
sed -i "s/\$database_password = 'cactiuser';/\$database_password = 'P@ssw0rd1';/" /etc/cacti/db.php

# Fix the php.ini script
cp /etc/php.ini /etc/php.ini.orig
sed -i 's/;date.timezone =/date.timezone = America\/Regina/' /etc/php.ini

#restart the httpd.servicee
systemctl restart httpd.service

# Set up the cacti cron
sed -i 's/#//g' /etc/cron.d/cacti
setenforce 0
