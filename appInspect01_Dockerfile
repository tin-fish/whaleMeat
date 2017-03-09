FROM centos:latest
RUN yum -y update && yum install -y curl
COPY splunk-appinspect-1.2.0.73.tar.gz /
COPY NameOfApp.tgz /
COPY get-pip.py /
RUN python get-pip.py
RUN pip install /splunk-appinspect-1.2.0.73.tar.gz
CMD splunk-appinspect inspect NameOfApp.tar.gz
