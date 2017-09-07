#!/bin/bash
echo "Running Splunk setup routines"
echo "OPTIMISTIC_ABOUT_FILE_LOCKING = 1" >> /opt/splunk/etc/splunk-launch.conf
echo -n "queen.hive     " >> /etc/hosts
echo $SIRE >> /etc/hosts
echo -n "cluster.hive     " >> /etc/hosts
echo -n $NET >> /etc/hosts
echo ".169" >> /etc/hosts
/birth_poc.py
/opt/splunk/bin/splunk start --accept-license
/opt/splunk/bin/splunk start && hostname | xargs /opt/splunk/bin/splunk set servername $1 -auth admin:changeme
/opt/splunk/bin/splunk edit cluster-config -mode master -replication_factor 1 -search_factor 1 -secret $CLUSTERPASSWORD -auth admin:changeme
/opt/splunk/bin/splunk init shcluster-config -mgmt_uri https://127.0.0.1:8089 -replication_port 9200 -secret $CLUSTERPASSWORD
sed -i 's/disabled = 0//; s/replication_factor = 1//; s/search_factor = 1//; s/mode = master//; s/\[replication_port:\/\/9200\]//; s/mgmt_uri = https:\/\/127.0.0.1:8089//;' /opt/splunk/etc/system/local/server.conf
/opt/splunk/bin/splunk set deploy-poll $SIRE:8089
/opt/splunk/bin/splunk restart
export CLUSTERPASSWORD="NoneOfYourBusiness"
echo "#!/bin/bash" > /start.sh
echo "/back_poc.py" >> /start.sh
echo "/opt/splunk/bin/splunk start" >> /start.sh
