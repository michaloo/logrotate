# Docker logrotate

[![](https://imagelayers.io/badge/michaloo/logrotate:latest.svg)](https://imagelayers.io/?images=michaloo/logrotate:latest 'Get your own badge on imagelayers.io')

Docker image with golang cron replacement:

- [go-cron](https://github.com/michaloo/go-cron)

which rotate logs from all docker containers found in provided docker installation.

By default it runs every hour and rotate files daily.

Logrotate interval is controlled by `GOCRON_SCHEDULER` environmental variable according to [golang cron package format](http://godoc.org/github.com/robfig/cron#hdr-CRON_Expression_Format).

Rotation config is created using `/app/logrotate.tmpl` and could be easily overwritten in custom Dockerfile:

`ADD my-custom-logrotate-template.tmpl /app/logrotate.tmpl`


# Example usage

`docker run -d -v /var/lib/docker:/var/lib/docker michaloo/logrotate`
