#!/bin/bash
bash generate_config.sh $1 $2
gcloud compute scp --zone us-west1-b $1.cfg dara_ung@nagios-install:/etc/nagios/servers
gcloud compute ssh --zone us-west1-b dara_ung@nagios-install --command='sudo /usr/sbin/nagios -v /etc/nagios/nagios.cfg'

#chmod is the permeission read write execute.
#dara_ung@nagios-install meaning that login as dara_ung and go to this server (nagios-install)
