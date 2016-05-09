FROM debian:jessie
MAINTAINER Michal Raczka me@michaloo.net

# set default configuration
ENV DOCKER_DIR /var/lib/docker/
ENV GOCRON_SCHEDULER 0 0 * * * *

ENV LOGROTATE_MODE daily
ENV LOGROTATE_ROTATE 7

ENTRYPOINT [ "/bin/bash" ]
CMD [ "/app/start" ]

WORKDIR /app

# install curl
RUN apt-get update \
    && apt-get install -y curl logrotate \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install go-cron
RUN curl -sL https://github.com/michaloo/go-cron/releases/download/v0.0.2/go-cron.tar.gz \
    | tar -x -C /usr/local/bin

# clear logrotate default configuration and modify logrotate script
# add the template and enable debug mode
RUN rm /etc/logrotate.d/* \
    && sed -i \
    -e 's/^\/usr\/sbin\/logrotate.*/\/usr\/sbin\/logrotate \-v \/etc\/logrotate.conf/' \
    /etc/cron.daily/logrotate

# copy project files
ADD . /app
