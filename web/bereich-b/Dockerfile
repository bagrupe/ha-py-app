# syntax=docker/dockerfile:1
# Build context: web/
FROM node:22.14.0-alpine AS build

WORKDIR /workspace

RUN apk add --no-cache python3 make g++ \
    && corepack enable

COPY . .
RUN pnpm --filter bereich-b... install --frozen-lockfile

ARG CI_COMMIT_REF_SLUG=none
ARG SENTRY_ENVIRONMENT=local
ARG SENTRY_ORG
ARG SENTRY_PROJECT
ARG SENTRY_URL
ARG NEXT_PUBLIC_SERVER_URL
ENV NEXT_TELEMETRY_DISABLED=1
RUN --mount=type=secret,id=SENTRY_AUTH \
    set -eu; \
    if [ -f /run/secrets/SENTRY_AUTH ]; then export SENTRY_AUTH="$(cat /run/secrets/SENTRY_AUTH)"; fi; \
    pnpm generate-sentry; \
    pnpm --filter bereich-b build

# Match the build stage so that sharp can load its musl binaries.
FROM node:22.14.0-alpine

WORKDIR /app

ENV NODE_ENV=production

RUN apk add --no-cache tzdata su-exec
ENV TZ=Europe/Berlin

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# In a monorepo, pnpm symlinks in bereich-b/node_modules resolve to
# ../../node_modules/.pnpm/*, so we must preserve the full directory structure.
COPY --from=build --chown=nextjs:nodejs /workspace/bereich-b/.next/standalone ./
COPY --from=build --chown=nextjs:nodejs /workspace/bereich-b/.next/static ./bereich-b/.next/static
COPY --from=build --chown=nextjs:nodejs /workspace/bereich-b/public ./bereich-b/public
# Only the seed assets — the seeder code is bundled into the server build (runs via onInit)
COPY --from=build --chown=nextjs:nodejs /workspace/bereich-b/src/dataseeder ./bereich-b/src/dataseeder
COPY bereich-b/docker/docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh \
  && mkdir -p ./bereich-b/uploads/media \
  && chown -R nextjs:nodejs ./bereich-b/uploads

EXPOSE 3000

ENV PORT=3000

WORKDIR /app/bereich-b

ENTRYPOINT ["/docker-entrypoint.sh"]

# server.js is created by next build from the standalone output
CMD ["sh", "-c", "HOSTNAME=0.0.0.0 node server.js"]
