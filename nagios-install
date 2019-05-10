#!/bin/bash   
#min nagios install 
#(this is for the first week of configuration.  We will be compiling from source later in the quarter)

#install enable and start the nagios program
yum install nagios
systemctl enable nagios
systemctl start nagios

setenforce 0

#install, enable and start the httpd
yum install httpd
systemctl enable httpd
systemctl start httpd

#install, enable and start the nrpe
yum install nrpe
systemctl enable nrpe
systemctl start nrpe

#install ngaios-plugiins-alla and nrpe
yum install nagios-plugins-all
yum install nagios-plugins-nrpe

#username and password
htpasswd -b -c /etc/nagios/passwd nagiosadmin nagiosadmin

#set the nagios to read and write
chmod 666 /var/log/nagios/nagios.log 

mkdir /etc/nagios/servers

#uncommand the line to enable nagios.cfg
sed -i '51 s/^#//' /etc/nagios/nagios.cfg  # Courtesey of Chuan
echo "define command{
                                command_name check_nrpe
                                command_line /usr/lib64/nagios/plugins/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
                                }" >> /etc/nagios/objects/commands.cfg
systemctl restart nagios

#Further configuration:
#https://assets.nagios.com/downloads/nagioscore/docs/nagioscore/4/en/monitoring-publicservices.html (Links to an external site.)


#verify
#/usr/sbin/nagios -v /etc/nagios/nagios.cfg


dd if=/dev/zero of=/swap bs=1024 count=2097152
mkswap /swap && chown root. /swap && chmod 0600 /swap && swapon /swap
echo /swap swap swap defaults 0 0 >> /etc/fstab
echo vm.swappiness = 0 >> /etc/sysctl.conf && sysctl -p

#pulling the raw file from nicole site on the github. 
 cd /etc/nagios
# wget https://raw.githubusercontent.com/nic-instruction/NTI-320/
#master/automation/generate_config.sh
