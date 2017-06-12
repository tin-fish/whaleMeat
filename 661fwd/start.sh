#!/bin/bash
echo "Running Splunk setup routines"
/opt/splunkforwarder/bin/splunk start --accept-license
/opt/splunkforwarder/bin/splunk start && hostname | xargs /opt/splunkforwarder/bin/splunk set servername $1 -auth admin:changeme
/opt/splunkforwarder/bin/splunk set deploy-poll $SIRE:8089
/opt/splunkforwarder/bin/splunk restart
echo "#!/bin/bash" > /start.sh
echo "/opt/splunkforwarder/bin/start" >> /start.sh
