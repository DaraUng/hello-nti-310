#!/bin/bash
for servername in $(gcloud compute instances list | awk '{print $1}' | sed "1 d" | grep -v nagios-install );  do 
    echo $servername;
    serverip=$( gcloud compute instances list | grep $servername | awk '{print $4}');
    echo $serverip ;
    bash scp_nagios $servername $serverip
done

gcloud compute ssh --zone us-west1-b dara_ung@nagios-install --command='sudo systemctl restart nagios'

