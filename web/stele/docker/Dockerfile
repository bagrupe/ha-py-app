FROM nginx:1.27-alpine

RUN apk add --no-cache curl fcgiwrap gettext spawn-fcgi tzdata
ENV TZ=Europe/Berlin

COPY dist /usr/share/nginx/html
COPY docker/nginx/default.conf.template /etc/nginx/templates/default.conf.template
COPY docker/health-ready.sh /usr/local/bin/health-ready
COPY docker/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /usr/local/bin/health-ready /docker-entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/docker-entrypoint.sh"]
