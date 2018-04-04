FROM centos:latest
LABEL maintainer="@tin_fish"
LABEL description="tin_fish Splunk Universal Forwarder 7.0.3 Build"
LABEL version="v1.1"
#
# Handy and Splunk pre-requisites
#
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
RUN yum install openssh-server -y
RUN yum install openssh-clients -y
RUN chkconfig ntpd on
RUN ntpdate pool.ntp.org
RUN export PATH=$PATH:/opt/splunkforwarder/bin
#RUN wget -O splunkforwarder.rpm 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=6.4.3&product=universalforwarder&filename=splunkforwarder-6.4.3-b03109c2bad4-linux-2.6-x86_64.rpm&wget=true'
#RUN wget -O splunkforwarder.rpm 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=6.6.0&product=universalforwarder&filename=splunkforwarder-6.6.0-1c4f3bbe1aea-linux-2.6-x86_64.rpm&wget=true'
#RUN wget -O splunkforwarder.rpm 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=6.6.1&product=universalforwarder&filename=splunkforwarder-6.6.1-aeae3fe0c5af-linux-2.6-x86_64.rpm&wget=true'
#RUN wget -O splunkforwarder.rpm 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=6.6.2&product=universalforwarder&filename=splunkforwarder-6.6.2-4b804538c686-linux-2.6-x86_64.rpm&wget=true'
#RUN wget -O splunkforwarder.rpm 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=6.6.3&product=universalforwarder&filename=splunkforwarder-6.6.3-e21ee54bc796-linux-2.6-x86_64.rpm&wget=true'
RUN wget -O splunkforwarder.rpm 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=7.0.3&product=universalforwarder&filename=splunkforwarder-7.0.3-fa31da744b51-linux-2.6-x86_64.rpm&wget=true'
RUN rpm -i splunkforwarder.rpm
RUN rm splunkforwarder.rpm
COPY splunkclouduf.spl /splunkclouduf.spl
COPY splunkclouduf_core.spl /splunkclouduf_core.spl
COPY start.sh /start.sh
COPY heartbeat.py /heartbeat.py
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "/get-pip.py"
RUN python /get-pip.py
RUN pip install splunk-sdk
RUN echo "[https]" > /etc/python/cert-verification.cfg
RUN echo "verify=disable" >> /etc/python/cert-verification.cfg
CMD /start.sh
