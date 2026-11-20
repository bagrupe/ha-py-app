FROM nginx:1.25.1-alpine

COPY storybook-static /usr/share/nginx/html
EXPOSE 80
