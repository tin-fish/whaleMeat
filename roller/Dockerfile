FROM centos:latest
LABEL maintainer="@tin_fish"
LABEL description="tin_fish H-B-W-T-R"
LABEL version="v1.0"
RUN yum install wget -y
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "/get-pip.py"
RUN python /get-pip.py
RUN pip install splunk-sdk
RUN echo "[https]" > /etc/python/cert-verification.cfg
RUN echo "verify=disable" >> /etc/python/cert-verification.cfg
COPY ./bucketeer.py /bucketeer.py
CMD /bucketeer.py
