FROM centos:latest
LABEL maintainer="@tin_fish"
LABEL description="Splunk Enterprise 6.6.0 Build"
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
RUN yum install python-requests -y
RUN yum install git -y
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
#
# Splunk Enterprise Installation
#
RUN wget -O splunk-6.6.0-1c4f3bbe1aea-linux-2.6-x86_64.rpm 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=6.6.0&product=splunk&filename=splunk-6.6.0-1c4f3bbe1aea-linux-2.6-x86_64.rpm&wget=true'
RUN rpm -i splunk-6.6.0-1c4f3bbe1aea-linux-2.6-x86_64.rpm
#RUN wget -O splunk-6.4.1-debde650d26e-linux-2.6-x86_64.rpm 'https://www.splunk.com/page/download_track?file=6.4.1/linux/splunk-6.4.1-debde650d26e-linux-2.6-x86_64.rpm&ac=&wget=true&name=wget&platform=Linux&architecture=x86_64&version=6.4.1&product=splunk&typed=release'
#RUN rpm -i splunk-6.4.1-debde650d26e-linux-2.6-x86_64.rpm
COPY ./start.sh /start.sh
COPY ./birth_poc.py /birth_poc.py
COPY ./back_poc.py /back_poc.py
COPY ./slack-notification-alert_102.tgz /slack-notification-alert_102.tgz
RUN tar xf /slack-notification-alert_102.tgz -C /opt/splunk/etc/apps/
RUN rm /slack-notification-alert_102.tgz
EXPOSE 8000
EXPOSE 8080
EXPOSE 8089
EXPOSE 9997
CMD /start.sh && /usr/sbin/sshd -D
