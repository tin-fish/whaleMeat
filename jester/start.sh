#!/bin/bash
echo "Running Splunk setup routines..."
echo "OPTIMISTIC_ABOUT_FILE_LOCKING = 1" >> /opt/splunkforwarder/etc/splunk-launch.conf
/opt/splunkforwarder/bin/splunk start --accept-license
hostname | xargs /opt/splunkforwarder/bin/splunk set servername $1 -auth admin:changeme
/opt/splunkforwarder/bin/splunk install app /splunkclouduf_core.spl -auth admin:changeme
/opt/splunkforwarder/bin/splunk restart
/opt/splunkforwarder/bin/splunk install app /splunkclouduf.spl -auth admin:changeme
/opt/splunkforwarder/bin/splunk stop
echo "#!/bin/bash" > /start.sh
echo "/opt/splunkforwarder/bin/splunk start" >> /start.sh
echo "sleep 30" >> /start.sh
echo "/heartbeat.sh" >> /start.sh
