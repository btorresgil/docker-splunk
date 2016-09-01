FROM centos:centos7

MAINTAINER Brian Torres-Gil <btorresgil@dralth.com>

ENV REFRESHED_AT 2016-08-31

# Not needed for Splunk, maybe for other software later
#RUN yum localinstall -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm && \
#RUN yum clean all

# Use wget to grab a version of Splunk
RUN yum install -y wget
RUN wget -O /splunk.rpm "https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=6.4.3&product=splunk&filename=splunk-6.4.3-b03109c2bad4-linux-2.6-x86_64.rpm&wget=true"

# Build everything locally.. (its faster)
#COPY splunk-6.4.3-b03109c2bad4-linux-2.6-x86_64.rpm /splunk.rpm

RUN yum localinstall -y /splunk.rpm 
RUN rm -f /splunk.rpm 

# Statically copy apps into the container
#COPY main_app/ /opt/splunk/etc/apps/main/

# Sets Splunk settings
COPY init/ /init/

# Move the existing configuration out so host-mapped volumes
# don't overwrite the files. Configuration will be copied back
# in during container setup on first run.
RUN mkdir /local /local/system /local/apps /local/auth
RUN cp -R /opt/splunk/etc/system/local/* /local/system
RUN cp -R /opt/splunk/etc/apps/* /local/apps
RUN cp -R /opt/splunk/etc/auth/* /local/auth

# Index directory must be a volume for Splunk to work
VOLUME /opt/splunk/var/lib/splunk

# These directories contain the Splunk configuration
# Based on http://docs.splunk.com/Documentation/Splunk/6.2.0/Admin/Configurationfiledirectories
VOLUME /opt/splunk/etc/system/local
VOLUME /opt/splunk/etc/users
VOLUME /opt/splunk/etc/apps
VOLUME /opt/splunk/etc/auth

EXPOSE 8000 8089 9997 514/udp

ENTRYPOINT ["/bin/bash", "-e", "/init/start"]
CMD ["run"]
