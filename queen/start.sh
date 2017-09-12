#!/bin/bash
echo "Running Splunk setup routines"
echo "STARTING WITH MacOSX fix"
echo "#" >> /opt/splunk/etc/splunk-launch.conf
echo "# TinFish MacOS Fix" /opt/splunk/etc/splunk-launch.conf
echo "OPTIMISTIC_ABOUT_FILE_LOCKING = 1" >> /opt/splunk/etc/splunk-launch.conf
echo "DNS entry stuff.  Let's see if this works..."
echo -n $IP >> /etc/hosts
echo "	queen.hive" >> /etc/hosts
echo -n $CLUSTER >> /etc/hosts
echo -n "	cluster.hive" >> /etc/hosts
echo "GENERATE NOTIFICATION TO SLACK"
/birth_poc.py
echo "SPLUNK TIME"
/opt/splunk/bin/splunk start --accept-license
/opt/splunk/bin/splunk start && hostname | xargs /opt/splunk/bin/splunk set servername $1 -auth admin:changeme
/opt/splunk/bin/splunk edit cluster-config -mode master -replication_factor 1 -search_factor 1 -secret $CLUSTERPASSWORD -auth admin:changeme
/opt/splunk/bin/splunk init shcluster-config -mgmt_uri https://127.0.0.1:8089 -replication_port 9200 -secret $CLUSTERPASSWORD
sed -i 's/disabled = 0//; s/replication_factor = 1//; s/search_factor = 1//; s/mode = master//; s/\[replication_port:\/\/9200\]//; s/mgmt_uri = https:\/\/127.0.0.1:8089//;' /opt/splunk/etc/system/local/server.conf
echo " " >> /opt/splunk/etc/system/local/server.conf
echo "[indexer_discovery]" >> /opt/splunk/etc/system/local/server.conf
echo -n "pass4SymmKey = " >> /opt/splunk/etc/system/local/server.conf
echo "$CLUSTERPASSWORD" >> /opt/splunk/etc/system/local/server.conf
echo " " >>/opt/splunk/etc/system/local/outputs.conf
echo "[indexer_discovery:cluster]" /opt/splunk/etc/system/local/outputs.conf
echo -n "pass4SymmKey = " >> /opt/splunk/etc/system/local/outputs.conf
echo "$CLUSTERPASSWORD" >> /opt/splunk/etc/system/local/outputs.conf
rm -rf /opt/splunk/etc/deployment-apps
git clone -b $HIVE https://github.com/tin-fish/deployment-apps.git /opt/splunk/etc/deployment-apps
cp -R /opt/splunk/etc/deployment-apps/_this_deployment_server /opt/splunk/etc/apps/
/opt/splunk/bin/splunk restart
echo "#!/bin/bash" > /start.sh
echo "/back_poc.py" >> /start.sh
echo "cd /opt/splunk/etc/deployment-apps;git pull" >> /start.sh
echo "/opt/splunk/bin/splunk start" >> /start.sh
