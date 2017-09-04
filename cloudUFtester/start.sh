#!/bin/bash
# start.sh for cloudUFtester
# accepts licence, installs UF and stops - ready for use.
/opt/splunkforwarder/bin/splunk start --accept-license
/opt/splunkforwarder/bin/splunk install app /splunkclouduf.spl -auth admin:changeme
echo "OPTIMISTIC_ABOUT_FILE_LOCKING = 1" >> /opt/splunkforwarder/etc/splunk-launch.conf
/opt/splunkforwarder/bin/splunk start && hostname | xargs /opt/splunkforwarder/bin/splunk set servername $1 -auth admin:changeme
/opt/splunkforwarder/bin/splunk stop
