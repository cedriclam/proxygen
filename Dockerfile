#
# Dockerfile - Facebook Proxygen Base image
# (https://github.com/cedriclam/proxygen)
#
# - Build
# docker build --rm -t proxygen .
#
# - Run
# docker run -d --name="proxygen" -h "proxygen" proxygen
#
# - SSH
# ssh `docker inspect -f '{{ .NetworkSettings.IPAddress }}' proxygen`
#
# Base images
FROM     ubuntu:14.04
MAINTAINER Cedric Lamoriniere <cedric.lamoriniere@gmail.com>

# Last Package Update & Install
RUN apt-get update ; apt-get install -y git openssh-server nano

# ENV
ENV SRC_DIR /opt

# proxygen
ADD proxygen /opt/proxygen

# set the working directory
WORKDIR /opt/proxygen

RUN sh ./deps.sh
RUN sh ./reinstall.sh

# SSH
RUN mkdir /var/run/sshd
RUN sed -i 's/without-password/yes/g' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

# Root password
RUN echo 'root:proxygen' |chpasswd

# Port
EXPOSE 22 11000

# Daemon
CMD ["/usr/bin/supervisord"]
