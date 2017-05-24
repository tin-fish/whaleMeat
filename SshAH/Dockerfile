FROM centos:latest
LABEL maintainer="@tin_fish"
LABEL description="Splunk Enterprise 6.6.0 Build"
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
# And our start...
#
CMD /usr/sbin/sshd -D
