#cloudUFtester written by @tin_fish
# 09.09.2016
# This is a fairly noddy Docker Container that compiles a Centos image, adds a few handy pre-requisites (tbh
# just borrowed from the internal vm build documentation), installs the latest Splunk Universal Forwarder and
# then runs a start shell script. That runs and preps a splunkclouduf.spl file (downloadable from Splunk>Cloud).
# To use, run in interactive mode and start Splunk.
#
FROM centos:latest
MAINTAINER @tin_fish
ENV PATH=$PATH:/opt/splunkforwarder/bin/
RUN yum install psmisc -y
RUN yum install lsof -y
RUN yum install dstat -y
RUN yum install wget -y
RUN yum install gdb -y
RUN yum install sysstat -y
RUN yum install strace -y
RUN yum install tcpdump -y
RUN yum install telnet -y
RUN yum install which -y
RUN yum install ntp ntpdate ntp-doc -y
RUN chkconfig ntpd on
RUN ntpdate pool.ntp.org
#RUN wget -O splunkforwarder.rpm 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=6.4.3&product=universalforwarder&filename=splunkforwarder-6.4.3-b03109c2bad4-linux-2.6-x86_64.rpm&wget=true'
#RUN wget -O splunkforwarder.rpm 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=6.6.0&product=universalforwarder&filename=splunkforwarder-6.6.0-1c4f3bbe1aea-linux-2.6-x86_64.rpm&wget=true'
RUN wget -O splunkforwarder.rpm 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=6.6.2&product=universalforwarder&filename=splunkforwarder-6.6.2-4b804538c686-linux-2.6-x86_64.rpm&wget=true'
RUN rpm -i splunkforwarder.rpm
COPY start.sh /start.sh
COPY splunkclouduf.spl /splunkclouduf.spl
RUN /start.sh
ENTRYPOINT ["/bin/bash"]
