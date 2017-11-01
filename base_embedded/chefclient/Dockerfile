FROM ubuntu:14.04.2

RUN apt-get -yqq update
RUN apt-get -yqq install curl lsb-release
RUN curl -L https://getchef.com/chef/install.sh | bash -s -- -v 12.8.1
RUN apt-get -yqq clean

# Make Chef available as a volume
VOLUME /opt/chef

ENTRYPOINT ["tail", "-f", "/dev/null"]