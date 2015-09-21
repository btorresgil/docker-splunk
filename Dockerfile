FROM centos:centos7

MAINTAINER Brian Torres-Gil <btorresgil@dralth.com>

ENV REFRESHED_AT 2015-07-07

# Not needed for Splunk, maybe for other software later
#RUN yum localinstall -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm && \
#RUN yum clean all

# Use wget to grab a version of Splunk
RUN yum install -y wget
RUN wget -O /splunk.rpm "http://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=Linux&version=6.2.3&product=splunk&filename=splunk-6.2.3-264376-linux-2.6-x86_64.rpm&wget=true"

# Build everything locally.. (its faster)
#COPY splunk-6.2.3-264376-linux-2.6-x86_64.rpm /splunk.rpm

RUN yum localinstall -y /splunk.rpm 
RUN rm -f /splunk.rpm 

# Statically copy apps into the container
#COPY main_app/ /opt/splunk/etc/apps/main/

# Sets Splunk settings
COPY init/ /init/

VOLUME /opt/splunk/var/lib/splunk

EXPOSE 8000 8089 9997 514/udp

ENTRYPOINT ["/bin/bash", "-e", "/init/start"]
CMD ["run"]
