FROM centos:latest
LABEL maintainer="@tin_fish"
LABEL description="tin_fish Splunk Universal Forwarder 6.6.2 Build"
LABEL version="v1.0"
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
#
# SSHD configuration
#
RUN echo 'root:P0cP0c' | chpasswd
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN ssh-keygen -A
EXPOSE 22
RUN export PATH=$PATH:/opt/splunkforwarder/bin
#RUN wget -O splunkforwarder.rpm 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=6.4.3&product=universalforwarder&filename=splunkforwarder-6.4.3-b03109c2bad4-linux-2.6-x86_64.rpm&wget=true'
#RUN wget -O splunkforwarder.rpm 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=6.6.0&product=universalforwarder&filename=splunkforwarder-6.6.0-1c4f3bbe1aea-linux-2.6-x86_64.rpm&wget=true'
#RUN wget -O splunkforwarder.rpm 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=6.6.1&product=universalforwarder&filename=splunkforwarder-6.6.1-aeae3fe0c5af-linux-2.6-x86_64.rpm&wget=true'
#RUN wget -O splunkforwarder.rpm 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=6.6.2&product=universalforwarder&filename=splunkforwarder-6.6.2-4b804538c686-linux-2.6-x86_64.rpm&wget=true'
RUN wget -O splunkforwarder.rpm 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=6.6.3&product=universalforwarder&filename=splunkforwarder-6.6.3-e21ee54bc796-linux-2.6-x86_64.rpm&wget=true'
RUN rpm -i splunkforwarder.rpm
RUN rm splunkforwarder.rpm
COPY splunkclouduf.spl /splunkclouduf.spl
COPY start.sh /start.sh
CMD /start.sh && /usr/sbin/sshd -D
