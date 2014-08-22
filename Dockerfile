FROM ubuntu:14.04
MAINTAINER Michal Raczka me@michaloo.net

# install curl
RUN apt-get update && \
    apt-get install -y curl

# install docker-gen
RUN curl -sL https://github.com/jwilder/docker-gen/releases/download/0.3.2/docker-gen-linux-amd64-0.3.2.tar.gz | \
    tar -xz -C /usr/local/bin

# install go-cron
RUN curl -sL https://github.com/michaloo/go-cron/releases/download/v0.0.2/go-cron.tar.gz | \
    tar -x -C /usr/local/bin

# install forego
# RUN curl -o /usr/local/bin/forego \
#     -sL https://godist.herokuapp.com/projects/ddollar/forego/releases/current/linux-amd64/forego && \
#     chmod u+x /usr/local/bin/forego

# copy project files
ADD . /app
WORKDIR /app

# clear logrotate ubuntu installation and enable debug information
RUN rm /etc/logrotate.d/* && \
    sed -i -e 's/^\/usr\/sbin\/logrotate.*/\/usr\/sbin\/logrotate \-v \/etc\/logrotate.conf/' /etc/cron.daily/logrotate

# set default configuration
ENV DOCKER_HOST unix:///var/run/docker.sock
ENV DOCKER_DIR /var/lib/docker/
ENV GOCRON_SCHEDULER 0 0 * * * *

ENTRYPOINT [ "/bin/bash" ]
CMD [ "/app/start" ]
