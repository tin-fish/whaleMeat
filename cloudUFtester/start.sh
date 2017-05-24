#!/bin/bash
# start.sh for cloudUFtester
# accepts licence, installs UF and stops - ready for use.
/opt/splunkforwarder/bin/splunk start --accept-license
/opt/splunkforwarder/bin/splunk add monitor /var/log -auth admin:changeme
/opt/splunkforwarder/bin/splunk install app /splunkclouduf.spl -auth admin:changeme
/opt/splunkforwarder/bin/splunk stop
