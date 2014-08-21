FROM ubuntu:14.04
MAINTAINER Michal Raczka me@michaloo.net


RUN apt-get update && \
    apt-get install -y curl

RUN cd /usr/local/bin && \
    curl -L https://github.com/jwilder/docker-gen/releases/download/0.3.2/docker-gen-linux-amd64-0.3.2.tar.gz | \
    tar -xzv

# install go-cron
RUN cd /usr/local/bin && \
    curl -L https://github.com/michaloo/go-cron/releases/download/v0.0.2/go-cron.tar.gz | \
    tar -xv

# install forego
RUN cd /usr/local/bin && \
    curl -LO https://godist.herokuapp.com/projects/ddollar/forego/releases/current/linux-amd64/forego && \
    chmod u+x /usr/local/bin/forego

RUN mkdir /app
WORKDIR /app
ADD . /app

# RUN cp /app/app.conf /etc/supervisor/conf.d/app.conf

RUN rm /etc/logrotate.d/* && \
    sed -i -e 's/^\/usr\/sbin\/logrotate.*/\/usr\/sbin\/logrotate \-v \/etc\/logrotate.conf/' /etc/cron.daily/logrotate

# RUN cd /etc/cron.daily/ && ls . | grep -v logrotate | xargs rm && \
#     cd /etc/cron.weekly/ && ls . | grep -v logrotate | xargs rm && \
#     rm /etc/logrotate.d/* && \
#     sed -i -e 's/^\/usr\/sbin\/logrotate.*/\/usr\/sbin\/logrotate \-v \/etc\/logrotate.conf/' /etc/cron.daily/logrotate && \
#     echo "0 *   * * * root /etc/cron.daily/logrotate" >> /etc/crontab

# EXPOSE 80

ENV DOCKER_HOST unix:///var/run/docker.sock
ENV DOCKER_DIR /var/lib/docker/
ENV GOCRON_SCHEDULER 0 0 * * * *

ENTRYPOINT [ "/usr/local/bin/forego" ]
CMD [ "start" ]
