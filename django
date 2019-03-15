#!/bin/bash
#https://www.digitalocean.com/community/tutorials/how-to-use-postgresql-with-your-django-application-on-centos-7

yum -y install python-pip wget
pip install virtualenv
pip install --upgrade pip

#make myproject folder & make a copy
mkdir ~/myproject
cd ~/myproject

#get into the myprojectenv
virtualenv myprojectenv
source myprojectenv/bin/activate

pip install django psycopg2
django-admin.py startproject myproject .

wget -O ~/myproject/myproject/settings.py https://raw.githubusercontent.com/DaraUng/hello-nti-310/master/settings.py

#subnet
#10.142.0.0/32
python manage.py makemigrations
python manage.py migrate
