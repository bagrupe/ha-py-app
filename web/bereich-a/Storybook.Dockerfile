FROM nginx:1.25.1-alpine

COPY storybook-static /usr/share/nginx/html
COPY nginx/default.conf.template /app/
EXPOSE 80
