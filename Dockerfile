FROM ubuntu:14.04
MAINTAINER Michal Raczka me@michaloo.net


RUN apt-get update && \
    apt-get install -y curl supervisor

RUN cd /usr/local/bin && \
    curl -L https://github.com/jwilder/docker-gen/releases/download/0.3.2/docker-gen-linux-amd64-0.3.2.tar.gz | \
    tar -xzv

RUN mkdir /app
WORKDIR /app
ADD . /app

RUN cp /app/app.conf /etc/supervisor/conf.d/app.conf

#EXPOSE 80

ENV DOCKER_HOST unix:///var/run/docker.sock
ENV DOCKER_DIR /var/lib/docker/

CMD ["/usr/bin/supervisord"]