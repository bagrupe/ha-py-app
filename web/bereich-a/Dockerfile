FROM nginx:1.25.1-alpine

RUN apk add --no-cache curl fcgiwrap gettext spawn-fcgi tzdata
ENV TZ=Europe/Berlin

COPY dist /usr/share/nginx/html
COPY nginx/default.conf.template /app/
COPY docker/health-ready.sh /usr/local/bin/health-ready
COPY docker/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /usr/local/bin/health-ready /docker-entrypoint.sh

EXPOSE 80
ENV BACKEND_HOST backend
ENV CMS_UPSTREAM http://bereich-b:3000

ENTRYPOINT ["/docker-entrypoint.sh"]
