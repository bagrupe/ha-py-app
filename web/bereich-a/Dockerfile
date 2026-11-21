# syntax=docker/dockerfile:1
# Build context: web/
FROM node:22.14.0-alpine AS build

WORKDIR /workspace

RUN apk add --no-cache python3 make g++ \
    && corepack enable

COPY . .
RUN pnpm --filter bereich-a... install --frozen-lockfile

ARG CI_COMMIT_REF_SLUG=none
ARG CI_COMMIT_SHA
ARG SENTRY_ENVIRONMENT=local
ARG SENTRY_ORG
ARG SENTRY_PROJECT
ARG SENTRY_URL
# Secret contents do not invalidate the build cache, so CI supplies a config version.
ARG DEPLOYMENT_CONFIG_VERSION
RUN --mount=type=secret,id=deployment_env,target=/workspace/bereich-a/.env.production \
    --mount=type=secret,id=SENTRY_AUTH \
    set -eu; \
    if [ -f /run/secrets/SENTRY_AUTH ]; then export SENTRY_AUTH="$(cat /run/secrets/SENTRY_AUTH)"; fi; \
    pnpm generate-sentry; \
    pnpm --filter bereich-a build

FROM nginx:1.25.1-alpine

RUN apk add --no-cache curl fcgiwrap gettext spawn-fcgi tzdata
ENV TZ=Europe/Berlin

COPY --from=build /workspace/bereich-a/dist /usr/share/nginx/html
COPY bereich-a/nginx/default.conf.template /app/
COPY bereich-a/docker/health-ready.sh /usr/local/bin/health-ready
COPY bereich-a/docker/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /usr/local/bin/health-ready /docker-entrypoint.sh

EXPOSE 80
ENV BACKEND_HOST backend
ENV CMS_UPSTREAM http://bereich-b:3000

ENTRYPOINT ["/docker-entrypoint.sh"]
